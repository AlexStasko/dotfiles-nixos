local function init()
  require 'astasko.vim'.init()
  require 'astasko.theme'.init()
  require 'astasko.languages'.init()
  require 'astasko.treesitter'.init()
  require 'astasko.completion'.init()
  require 'astasko.telescope'.init()
  require 'astasko.floaterm'.init()
  require 'astasko.extras'.init()
end

return {
  init = init,
}
