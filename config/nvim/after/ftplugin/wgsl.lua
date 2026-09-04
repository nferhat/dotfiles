local contents = vim.fn.readfile(vim.fn.stdpath("config") .. "/after/queries/wgsl/highlights.scm")
local contents_str = table.concat(contents, "\n");
vim.treesitter.query.set("wgsl", "highlights", contents_str)
