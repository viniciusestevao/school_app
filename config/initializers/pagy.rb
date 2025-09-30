require 'pagy'
require 'pagy/extras/bootstrap'
require 'pagy/extras/i18n'

Pagy::I18n.load({ locale: 'pt-BR' }, { locale: 'pt' }, { locale: 'en' })
Pagy::DEFAULT[:limit] = 6
Pagy::DEFAULT[:items] = 10
Pagy::DEFAULT[:max_items] = 50
Pagy::DEFAULT[:params] = [:sort, :dir] 

# Parâmetros extras para preservar nos links de paginação
# Pagy::DEFAULT[:params] = [:q, :order]