return {
  "habamax/vim-godot",
  event = "VimEnter",
  config = function()
    local gdproject = io.open(vim.fn.getcwd() .. "/project.godot", "r")
    if gdproject then
      io.close(gdproject)

      -- Function to check if port 6006 is in use
      local function is_port_in_use(port)
        local handle = io.popen("ss -tuln | grep :" .. port)
        local result = handle:read "*a"
        handle:close()
        return result ~= ""
      end

      if not is_port_in_use(6006) then
        vim.fn.serverstart "./godothost"
      else
        print "Port 6006 is already in use."
      end
    end
  end,
}
