-- References
-- https://github.com/LazyVim/LazyVim
-- https://github.com/AstroNvim/AstroNvim
-- https://github.com/AstroNvim/astrocommunity
-- https://github.com/NvChad/NvChad
-- https://github.com/ayamir/nvimdots

-- Options
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.wrap = false
vim.opt.whichwrap = "b,s,h,l,<,>"
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.virtualedit = "block"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true

-- Keybindings
vim.g.mapleader = "<Space>"
vim.g.maplocalleader = ","
vim.keymap.set({ "i", "c" }, "jk", "<Esc>", { desc = "Back to normal mode" })
vim.keymap.set({ "n" }, "<C-h>", "<C-w>h", { desc = "Move focus to left" })
vim.keymap.set({ "n" }, "<C-j>", "<C-w>j", { desc = "Move focus to down" })
vim.keymap.set({ "n" }, "<C-k>", "<C-w>k", { desc = "Move focus to up" })
vim.keymap.set({ "n" }, "<C-l>", "<C-w>l", { desc = "Move focus to right" })

-- Auto Command
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		(vim.hl or vim.highlight).on_yank({ timeout = 1000, higroup = "IncSearch" })
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("restore_last_cursor_position", { clear = true }),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
	pattern = {
		"PlenaryTestPopup",
		"checkhealth",
		"dbout",
		"gitsigns-blame",
		"grug-far",
		"help",
		"lspinfo",
		"neotest-output",
		"neotest-output-panel",
		"neotest-summary",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "q", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("disable_auto_comment", { clear = true }),
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- lazy.nvim & Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	install = { colorscheme = { "habamax" } },
	checker = { enabled = true },
	ui = {
		size = { width = 0.92, height = 0.88 },
		wrap = true,
		border = "rounded",
	},
	performance = {
		disabled_plugins = {
			"matchit",
			"matchparen",
			"netrw",
			"netrwPlugin",
			"gzip",
			"tar",
			"tarPlugin",
			"zip",
			"zipPlugin",
			"getscript",
			"getscriptPlugin",
			"vimball",
			"vimballPlugin",
			"tohtml",
			"tutor",
			"rrhelper",
		},
	},
	spec = {
		{ "LazyVim/LazyVim" },
		{ import = "lazyvim.plugins" },
		{ import = "lazyvim.plugins.extras.coding.luasnip" },
		{ import = "lazyvim.plugins.extras.coding.nvim-cmp" },
		{ import = "lazyvim.plugins.extras.dap.core" },
		{ import = "lazyvim.plugins.extras.dap.nlua" },
		{ import = "lazyvim.plugins.extras.editor.aerial" },
		{ import = "lazyvim.plugins.extras.editor.illuminate" },
		{ import = "lazyvim.plugins.extras.editor.navic" },
		{ import = "lazyvim.plugins.extras.editor.neo-tree" },
		{ import = "lazyvim.plugins.extras.editor.outline" },
		{ import = "lazyvim.plugins.extras.editor.overseer" },
		{ import = "lazyvim.plugins.extras.editor.telescope" },
		{ import = "lazyvim.plugins.extras.formatting.black" },
		{ import = "lazyvim.plugins.extras.formatting.prettier" },
		{ import = "lazyvim.plugins.extras.lang.clangd" },
		{ import = "lazyvim.plugins.extras.lang.python" },
		{ import = "lazyvim.plugins.extras.linting.eslint" },
		{ import = "lazyvim.plugins.extras.lsp.none-ls" },
		{ import = "lazyvim.plugins.extras.test.core" },
		{ import = "lazyvim.plugins.extras.ui.indent-blankline" },
		{ import = "lazyvim.plugins.extras.ui.treesitter-context" },
		{
			"catppuccin/nvim",
			name = "catppuccin",
			lazy = false,
			config = function()
				require("catppuccin").setup({
					flavour = "mocha",
					background = {
						light = "latte",
						dark = "mocha",
					},
					transparent_background = false,
					float = {
						transparent = false,
						solid = false,
					},
					show_end_of_buffer = false,
					term_colors = false,
					dim_inactive = {
						enabled = false,
						shade = "dark",
						percentage = 0.20,
					},
					no_italic = false,
					no_bold = false,
					no_underline = false,
					styles = {
						comments = { "italic" },
						conditionals = { "italic" },
						loops = {},
						functions = { "bold" },
						keywords = { "bold" },
						strings = {},
						variables = {},
						numbers = {},
						booleans = {},
						properties = {},
						types = {},
						operators = {},
					},
					lsp_styles = {
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
							information = { "italic" },
							ok = { "italic" },
						},
						underlines = {
							errors = { "underline" },
							hints = { "underline" },
							warnings = { "underline" },
							information = { "underline" },
							ok = { "underline" },
						},
						inlay_hints = {
							background = true,
						},
					},
					color_overrides = {
						mocha = {
							base = "#11111b",
							mantle = "#11111b",
						},
					},
					custom_highlights = function(colors)
						return {
							Comment = { fg = colors.overlay1 },
							CursorLineNr = { fg = colors.green, style = { "bold" } },
						}
					end,
					default_integrations = true,
					auto_integrations = false,
					integrations = {
						aerial = false,
						alpha = false,
						barbar = false,
						barbecue = {
							dim_dirname = true,
							bold_basename = true,
							dim_context = false,
							alt_background = false,
						},
						beacon = false,
						blink_cmp = {
							style = "bordered",
						},
						blink_indent = false,
						buffon = false,
						coc_nvim = false,
						colorful_winsep = {
							enabled = false,
							color = "red",
						},
						dashboard = false,
						diffview = false,
						dropbar = {
							enabled = false,
							color_mode = false,
						},
						fern = false,
						fidget = false,
						flash = false,
						fzf = false,
						gitgraph = false,
						gitsigns = false,
						grug_far = false,
						harpoon = false,
						headlines = false,
						hop = false,
						indent_blankline = {
							enabled = true,
							scope_color = "lavender",
							colored_indent_levels = false,
						},
						leap = false,
						lightspeed = false,
						lir = {
							enabled = false,
							git_status = false,
						},
						lsp_saga = false,
						markview = false,
						mason = false,
						mini = {
							enabled = false,
							indentscope_color = "",
						},
						neotree = true,
						neogit = false,
						neotest = false,
						noice = true,
						notifier = false,
						cmp = true,
						copilot_vim = false,
						dap = true,
						dap_ui = true,
						navic = {
							enabled = true,
							custom_bg = "NONE",
						},
						notify = false,
						nvim_surround = false,
						nvimtree = false,
						treesitter_context = true,
						ts_rainbow2 = false,
						ts_rainbow = false,
						ufo = true,
						window_picker = false,
						octo = false,
						overseer = true,
						pounce = false,
						rainbow_delimiters = true,
						render_markdown = true,
						snacks = {
							enabled = false,
							indent_scope_color = "lavender",
						},
						symbols_outline = false,
						telekasten = false,
						telescope = {
							enabled = true,
						},
						lsp_trouble = true,
						dadbod_ui = false,
						gitgutter = false,
						illuminate = {
							enabled = true,
							lsp = false,
						},
						sandwich = false,
						signify = false,
						vim_sneak = false,
						vimwiki = false,
						which_key = true,
					},
				})
				vim.cmd.colorscheme("catppuccin")
			end,
		},
		{
			"rebelot/kanagawa.nvim",
			config = function()
				require("kanagawa").setup({
					compile = false,
					undercurl = true,
					commentStyle = { italic = true },
					functionStyle = {},
					keywordStyle = { italic = true },
					statementStyle = { bold = true },
					typeStyle = {},
					transparent = false,
					dimInactive = true,
					terminalColors = true,
					colors = {
						palette = {},
						theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
					},
					overrides = function(colors)
						return {}
					end,
					theme = "dragon",
					background = {
						dark = "dragon",
						light = "lotus",
					},
				})
			end,
		},
		{
			"rose-pine/neovim",
			config = function()
				require("rose-pine").setup({
					variant = "auto",
					dark_variant = "main",
					dim_inactive_windows = false,
					extend_background_behind_borders = true,
					enable = {
						terminal = true,
						legacy_highlights = true,
						migrations = true,
					},
					styles = {
						bold = true,
						italic = true,
						transparency = false,
					},
					groups = {
						border = "muted",
						link = "iris",
						panel = "surface",
						error = "love",
						hint = "iris",
						info = "foam",
						note = "pine",
						todo = "rose",
						warn = "gold",
						git_add = "foam",
						git_change = "rose",
						git_delete = "love",
						git_dirty = "rose",
						git_ignore = "muted",
						git_merge = "iris",
						git_rename = "pine",
						git_stage = "iris",
						git_text = "rose",
						git_untracked = "subtle",
						h1 = "iris",
						h2 = "foam",
						h3 = "rose",
						h4 = "gold",
						h5 = "pine",
						h6 = "foam",
					},
					palette = {
						moon = {
							base = "#18191a",
							overlay = "#363738",
						},
					},
					highlight_groups = {
						Comment = { fg = "foam" },
						StatusLine = { fg = "love", bg = "love", blend = 15 },
						VertSplit = { fg = "muted", bg = "muted" },
						Visual = { fg = "base", bg = "text", inherit = false },
					},
					before_highlight = function(group, highlight, palette) end,
				})
			end,
		},
		{
			"EdenEast/nightfox.nvim",
			config = function()
				require("nightfox").setup({
					options = {
						compile_path = vim.fn.stdpath("cache") .. "/nightfox",
						compile_file_suffix = "_compiled",
						transparent = false,
						terminal_colors = true,
						dim_inactive = false,
						module_default = true,
						colorblind = {
							enable = false,
							simulate_only = false,
							severity = {
								protan = 0,
								deutan = 0,
								tritan = 0,
							},
						},
						styles = {
							comments = "NONE",
							conditionals = "NONE",
							constants = "NONE",
							functions = "NONE",
							keywords = "NONE",
							numbers = "NONE",
							operators = "NONE",
							strings = "NONE",
							types = "NONE",
							variables = "NONE",
						},
						inverse = {
							match_paren = false,
							visual = false,
							search = false,
						},
						modules = {},
					},
					palettes = {},
					specs = {},
					groups = {},
				})
			end,
		},
		{
			"navarasu/onedark.nvim",
			config = function()
				require("onedark").setup({
					style = "darker",
					transparent = false,
					term_colors = true,
					ending_tildes = false,
					cmp_itemkind_reverse = false,
					toggle_style_key = nil,
					toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" },
					code_style = {
						comments = "italic",
						keywords = "none",
						functions = "none",
						strings = "none",
						variables = "none",
					},
					lualine = {
						transparent = false,
					},
					colors = {},
					highlights = {},
					diagnostics = {
						darker = true,
						undercurl = true,
						background = true,
					},
				})
			end,
		},
		{
			"projekt0n/github-nvim-theme",
			config = function()
				require("github-theme").setup({
					options = {
						compile_path = vim.fn.stdpath("cache") .. "/github-theme",
						compile_file_suffix = "_compiled",
						hide_end_of_buffer = true,
						hide_nc_statusline = true,
						transparent = false,
						terminal_colors = true,
						dim_inactive = false,
						module_default = true,
						styles = {
							comments = "NONE",
							functions = "NONE",
							keywords = "NONE",
							variables = "NONE",
							conditionals = "NONE",
							constants = "NONE",
							numbers = "NONE",
							operators = "NONE",
							strings = "NONE",
							types = "NONE",
						},
						inverse = {
							match_paren = false,
							visual = false,
							search = false,
						},
						darken = {
							floats = true,
							sidebars = {
								enable = true,
								list = {},
							},
						},
						modules = {},
					},
					palettes = {},
					specs = {},
					groups = {},
				})
			end,
		},
		{
			"marko-cerovac/material.nvim",
			config = function()
				require("material").setup({
					contrast = {
						terminal = false,
						sidebars = false,
						floating_windows = false,
						cursor_line = false,
						lsp_virtual_text = false,
						non_current_windows = false,
						filetypes = {},
					},
					styles = {
						comments = { [[ italic = true ]] },
						strings = { [[ bold = true ]] },
						keywords = { [[ underline = true ]] },
						functions = { [[ bold = true, undercurl = true ]] },
						variables = {},
						operators = {},
						types = {},
					},
					plugins = {
						"blink",
						"coc",
						"colorful-winsep",
						"dap",
						"dashboard",
						"eyeliner",
						"fidget",
						"flash",
						"gitsigns",
						"harpoon",
						"hop",
						"illuminate",
						"indent-blankline",
						"lspsaga",
						"mini",
						"neo-tree",
						"neogit",
						"neorg",
						"neotest",
						"noice",
						"nvim-cmp",
						"nvim-navic",
						"nvim-notify",
						"nvim-tree",
						"nvim-web-devicons",
						"rainbow-delimiters",
						"sneak",
						"telescope",
						"trouble",
						"which-key",
					},
					disable = {
						colored_cursor = false,
						borders = false,
						background = false,
						term_colors = false,
						eob_lines = false,
					},
					high_visibility = {
						lighter = false,
						darker = false,
					},
					lualine_style = "default",
					async_loading = true,
					custom_colors = nil,
					custom_highlights = {},
				})
			end,
		},
		{
			"nyoom-engineering/oxocarbon.nvim",
		},
		{
			"HiPhish/rainbow-delimiters.nvim",
			event = "InsertEnter",
			config = function()
				require("rainbow-delimiters.setup").setup({
					strategy = {
						[""] = "rainbow-delimiters.strategy.global",
						vim = "rainbow-delimiters.strategy.local",
					},
					query = {
						[""] = "rainbow-delimiters",
						lua = "rainbow-blocks",
					},
					priority = {
						[""] = 110,
						lua = 210,
					},
					highlight = {
						"RainbowDelimiterRed",
						"RainbowDelimiterOrange",
						"RainbowDelimiterYellow",
						"RainbowDelimiterGreen",
						"RainbowDelimiterBlue",
						"RainbowDelimiterCyan",
						"RainbowDelimiterViolet",
					},
				})
				vim.cmd("doautocmd FileType")
			end,
		},
	},
})
