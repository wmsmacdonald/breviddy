# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css.sass, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

%w( bits pages feedbacks ).each do |controller|
  Rails.application.config.assets.precompile += ["#{controller}.js.coffee", "#{controller}.css", "#{controller}.js"]
end
%w( pages feedbacks ).each do |controller|
  Rails.application.config.assets.precompile += ["fixed_page.css"]
end
%w( devise users ).each do |controller|
  Rails.application.config.assets.precompile += ["users.js.coffee", "users.css", "users.js"]
end
#Rails.application.config.assets.precompile += %w( users.css )