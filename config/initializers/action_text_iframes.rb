Rails.application.config.after_initialize do
  safe = if Rails::Html::Sanitizer.respond_to?(:safe_list_sanitizer)
           Rails::Html::Sanitizer.safe_list_sanitizer
         else
           Rails::Html::Sanitizer.white_list_sanitizer
         end

  #  Depois melhorar a segurança com CSP e validação do host do src
  safe.allowed_tags.add "iframe"
  %w[src width height allow allowfullscreen frameborder].each { |a| safe.allowed_attributes.add a }
end