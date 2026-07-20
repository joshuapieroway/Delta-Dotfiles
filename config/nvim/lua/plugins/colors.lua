local function enable_transparency()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
end
return {
    {
	"neanias/everforest-nvim",
	config = function()
	    vim.cmd.colorscheme "everforest"
	    enable_transparency()
	end
    },
    {
	"nvim-lualine/lualine.nvim",
	dependencies = {
	    "nvim-tree/nvim-web-devicons"
	},
	opts = {
	    theme = 'everforest',
	}
    },
}
