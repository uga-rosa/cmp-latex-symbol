local script_path = debug.getinfo(1, "S").source:sub(2)
local target_path = script_path:gsub("convert.lua$", "") .. "unimathsymbols.txt"
local output_path = script_path:gsub("convert.lua$", "") .. "unimathsymbols.lua"

---@type lsp.CompletionItem[]
local completion_items = {}

---@param doc string
---@return lsp.MarkupContent
local function format(doc)
    if vim.startswith(doc, "= ") then
        doc = doc:gsub("= (.-),", "alias: %1,")
    elseif vim.startswith(doc, "# ") then
        doc = doc:gsub("# (.-),", "approx: %1,")
    elseif vim.startswith(doc, "x ") then
        doc = doc:gsub("x (.-),", "reference: %1,")
    elseif vim.startswith(doc, "t ") then
        doc = doc:gsub("t (.-),", "text mode: %1,")
    end
    return {
        kind = "plaintext",
        value = doc:gsub(", ", "\n"),
    }
end

---@param literal string
---@param command string
local function add(literal, command, doc)
    table.insert(completion_items, {
        label = literal .. " " .. command,
        insertText = literal,
        filterText = command,
        documentation = format(doc),
    })
end

for line in io.lines(target_path) do
    if line:sub(1, 1) == "#" then
        goto continue
    end

    local comp = vim.split(line, "^", { plain = true })
    local literal = comp[2]
    if literal == "" then
        goto continue
    end

    if comp[3] ~= "" then
        add(literal, comp[3], comp[8])
    end
    if comp[4] ~= "" then
        add(literal, comp[4], comp[8])
    end

    ::continue::
end

local function write(fname, content)
    local f = assert(io.open(fname, "w"))
    f:write("return ")
    f:write(content)
    f:close()
end

write(output_path, vim.inspect(completion_items))
