local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
	return
end

local builtin = require("telescope.builtin")
if not builtin then
	return
end

local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
	return
end

telescope.setup({
	defaults = {
		mappings = {
			i = {
				["C-k"] = actions.move_selection_previous,
				["C-j"] = actions.move_selection_next,
				["C-q"] = actions.send_selected_to_qflist + actions.open_qflist,
			},
		},
	},
})

telescope.load_extension("fzf")

vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>fd", builtin.find_files, {}) -- find files within current working directory, respects .gitignore

local telescope = require("telescope")
local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup({
	defaults = {
		-- `hidden = true` is not supported in text grep commands.
		vimgrep_arguments = vimgrep_arguments,
	},
	pickers = {
		find_files = {
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
	},
})
