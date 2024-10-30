-----------------------------------------------------------------------------------
-- Common Functions
-----------------------------------------------------------------------------------

--- Returns the name of the current operating system.
-- It detects if the OS is WSL (Windows Subsystem for Linux) or regular Linux,
-- as well as other OS types like macOS and Windows.
-- @return string The name of the operating system.
local function get_os()
  local os_name = vim.loop.os_uname().sysname

  if os_name == "Linux" then
    local f = io.popen "uname -r" -- Get the kernel version
    if not f then return "Unknown" end

    local kernel_version = f:read "*a"
    f:close()

    -- Check if the kernel version contains "Microsoft" to identify WSL
    if kernel_version:match "Microsoft" then
      return "WSL"
    else
      return "Linux"
    end
  elseif os_name == "Darwin" then
    return "Mac"
  elseif os_name == "Windows_NT" then
    return "Windows"
  else
    return "Unknown"
  end
end

--- Returns a table of completion items.
-- This should include user-defined functions with their descriptions.
-- @return table A table of completion items.
local function get_completion_items()
  return {
    {
      label = "get_os",
      insertText = "get_os()",
      documentation = "Returns the name of the current operating system.",
    },
    -- 他の関数の補完アイテムも追加できます
  }
end

return {
  get_os = get_os,
  get_completion_items = get_completion_items,
}
