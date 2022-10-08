---@class LatexSymbolSource: cmp.Source
---@field items lsp.CompletionItem[]
local source = {}
source.__index = source

---@return LatexSymbolSource
function source.new()
    return setmetatable({}, source)
end

---@return string
function source:get_keyword_pattern()
    return [[\\\S\+]]
end

---@param request cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse)
function source:complete(request, callback)
    if self.items == nil then
        -- Initialize on the first completion.
        self.items = require("cmp_latex_symbol.unimathsymbols")
    end

    -- Since the keyword pattern is `\\\S\+`, the input would be at least two characters such as `\a`.
    local input = string.sub(request.context.cursor_before_line, request.offset)
    local candidates = self:_filter(input)
    callback(candidates)
end

---Avoid returning more than 4000 items and overloading the cmp body.
---@param input string
---@return lsp.CompletionItem[]
function source:_filter(input)
    local candidates = {}
    for _, item in pairs(self.items) do
        if vim.startswith(item.filterText, input) then
            table.insert(candidates, item)
        end
    end
    return candidates
end

return source
