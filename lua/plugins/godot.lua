return {
  "habamax/vim-godot",
  event = "VimEnter",
  config = function()
    local gdproject = io.open(vim.fn.getcwd() .. "/project.godot", "r")
    if gdproject then
      io.close(gdproject)
      print()
      -- Function to check if port 6006 is in use
      local function is_port_in_use(port)
        local handle = io.popen("ss -tuln | grep :" .. port)
        local result = handle:read "*a"
        handle:close()
        return result ~= ""
      end

      if not is_port_in_use(6006) then
        -- If you specify the relative path ./godothost, it will exit with an error.
        local serv = vim.fn.serverstart "godothost"
        print(serv)
      else
        print "Port 6006 is already in use."
      end
    end
  end,
  options = {
    g = {
      -- godot_executable = function()
      --         local common = require('user.common')
      --         local os = common.get_os()
      --         if os =
      -- '/mnt/d/Godot/Godot_v4.3-stable_mono_win64/Godot_v4.3-stable_mono_win64.exe'
      --       end
    },
  },
}
