defmodule Plug.Parsers.XML do
  @behaviour Plug.Parsers

  @impl true
  def init(opts) do
    {decoder, opts} = Keyword.pop(opts, :xml_decoder)
    {body_reader, opts} = Keyword.pop(opts, :body_reader, {Plug.Conn, :read_body, []})
    decoder = validate_decoder!(decoder)
    {body_reader, decoder, opts}
  end

  defp validate_decoder!(nil) do
    raise ArgumentError, "XML parser expects an :xml_decoder option"
  end

  defp validate_decoder!({module, fun, args} = mfa)
       when is_atom(module) and is_atom(fun) and is_list(args) do
    arity = length(args) + 1

    if Code.ensure_compiled(module) != {:module, module} do
      raise ArgumentError,
            "invalid :xml_decoder option. The module #{inspect(module)} is not " <>
              "loaded and could not be found"
    end

    if not function_exported?(module, fun, arity) do
      raise ArgumentError,
            "invalid :xml_decoder option. The module #{inspect(module)} must " <>
              "implement #{fun}/#{arity}"
    end

    mfa
  end

  defp validate_decoder!(decoder) when is_atom(decoder) do
    validate_decoder!({decoder, :decode!, []})
  end

  defp validate_decoder!(decoder) do
    raise ArgumentError,
          "the :xml_decoder option expects a module, or a three-element " <>
            "tuple in the form of {module, function, extra_args}, got: #{inspect(decoder)}"
  end

  @impl true
  def parse(conn, _type, subtype, _headers, {{mod, fun, args}, decoder, opts}) do
    if subtype == "xml" or String.ends_with?(subtype, "+xml") do
      apply(mod, fun, [conn, opts | args]) |> decode(decoder)
    else
      {:next, conn}
    end
  end

  def parse(conn, _type, _subtype, _headers, _opts) do
    {:next, conn}
  end

  defp decode({:ok, "", conn}, _decoder) do
    {:ok, %{}, conn}
  end

  defp decode({:ok, body, conn}, {module, fun, args}) do
    try do
      apply(module, fun, [body | args])
    rescue
      e -> raise Plug.Parsers.ParseError, exception: e
    else
      terms -> decoded_result(terms, conn)
    end
  end

  defp decode({:more, _, conn}, _decoder) do
    {:error, :too_large, conn}
  end

  defp decode({:error, :timeout}, _decoder) do
    raise Plug.TimeoutError
  end

  defp decode({:error, _}, _decoder) do
    raise Plug.BadRequestError
  end

  defp decoded_result([terms], conn) do
    decoded_result(terms, conn)
  end

  defp decoded_result(terms, conn) when is_map(terms) do
    {:ok, terms, conn}
  end

  defp decoded_result(terms, conn) do
    {:ok, %{"_xml" => terms}, conn}
  end

  # XML specific

  defp combine_values([]), do: []

  defp combine_values(values) do
    if Enum.all?(values, &is_binary(&1)) do
      [List.to_string(values)]
    else
      values
    end
  end

  defp parse_record({:xmlElement, name, _, _, _, _, _, attributes, elements, _, _, _}, options) do
    value = combine_values(parse_record(elements, options))
    name = parse_name(name, options)
    [%{name: name, attr: parse_attribute(attributes), value: value}]
  end

  defp parse_record({:xmlText, _, _, _, value, _}, _) do
    string_value = String.trim(to_string(value))

    if String.length(string_value) > 0 do
      [string_value]
    else
      []
    end
  end

  defp parse_record({:xmlComment, _, _, _, value}, options) do
    if options[:comments] do
      [%{name: :comments, attr: [], value: String.trim(to_string(value))}]
    else
      []
    end
  end

  defp parse_record([], _), do: []

  defp parse_record([head | tail], options) do
    parse_record(head, options) ++ parse_record(tail, options)
  end

  defp parse_attribute([]), do: []

  defp parse_attribute({:xmlAttribute, name, _, _, _, _, _, _, value, _}) do
    [{name, to_string(value)}]
  end

  defp parse_attribute([head | tail]) do
    parse_attribute(head) ++ parse_attribute(tail)
  end

  defp parse_name(name, %{strip_namespaces: true}) do
    name
    |> to_string
    |> String.split(":")
    |> List.last()
    |> Macro.underscore()
    |> String.to_atom()
  end

  defp parse_name(name, _), do: name
end
