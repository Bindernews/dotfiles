
local function Trust(input)
    -- TODO find local directory .vimrc
    vim.opt.modeline = true
end

-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
vim.api.nvim_create_user_command("Trust", Trust, {
    nargs = 0,
})

