# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css.sass, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

%w( bits pages feedbacks users).each do |controller|
  Rails.application.config.assets.precompile += ["#{controller}.css", "#{controller}.js"]
end

Rails.application.config.assets.precompile += ["fixed_page.css"]
Rails.application.config.assets.precompile += ["new_bit.js"]
Rails.application.config.assets.precompile += %w( pagination.js )
