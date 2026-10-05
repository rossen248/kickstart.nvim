local pw = os.getenv 'HOGENT_SQL_PW'
local base = 'sqlserver://sa:' .. pw .. '@localhost:1433?TrustServerCertificate=true&database='

return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    vim.g.db_ui_save_location = vim.fn.stdpath 'config' .. '/db_ui'
    vim.keymap.set('v', '<leader>e', ':DB<CR>', { desc = 'Execute SQL' })

    vim.g.dbs = {
      { name = 'Northwind', url = base .. 'Northwind' },
      { name = 'VoetbalDB', url = base .. 'VoetbalDB' },
      { name = 'NorthwindDWH', url = base .. 'NorthwindDWH' },
      { name = 'AirfaresDWH', url = base .. 'AirfaresDWH' },
    }

    local db_by_path = {
      { pattern = '*/oefeningen/northwind/*.sql', url = base .. 'Northwind' },
      { pattern = '*/oefeningen/voetbal/*.sql', url = base .. 'VoetbalDB' },
      { pattern = '*/ch7-dwh/scripts/*NorthwindDWH*.sql', url = base .. 'NorthwindDWH' },
      { pattern = '*/ch7-dwh/scripts/*AirfaresDWH*.sql', url = base .. 'AirfaresDWH' },
    }

    for _, entry in ipairs(db_by_path) do
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = entry.pattern,
        callback = function()
          vim.b.db = entry.url
        end,
      })
    end
  end,
}
