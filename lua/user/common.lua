-----------------------------------------------------------------------------------
-- Common Functions
-----------------------------------------------------------------------------------

--- Returns the name of the current operating system.
-- It detects if the OS is WSL (Windows Subsystem for Linux) or regular Linux,
-- as well as other OS types like macOS and Windows.
-- @return string The name of the operating system.
local function get_os()
  local os_name = vim.uv.os_uname().sysname

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

--- Checks if the current project is a Unity project.
-- @return boolean True if it is a Unity project, false otherwise.
local function is_unity()
  local is_unity_project = vim.fn.glob "ProjectSettings/ProjectVersion.txt" ~= ""
  if is_unity_project then
    return true
  else
    return false
  end
end

--- Checks if the current project is a Godot project.
-- @return boolean True if it is a Godot project, false otherwise.
local function is_godot()
  local is_godot_project = vim.fn.glob "project.godot"
  if is_godot_project then
    return true
  else
    return false
  end
end

return {
  get_os = get_os,
  is_unity = is_unity,
  is_godot = is_godot,
}
