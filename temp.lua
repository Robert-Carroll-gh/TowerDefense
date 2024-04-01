local jobID = vim.fn.jobstart("lovec.exe .", ...)
local pid = vim.fn.jobpid(jobID)
print(jobID)
print(pid)
