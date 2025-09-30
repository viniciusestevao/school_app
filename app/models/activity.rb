class Activity < ApplicationRecord
  belongs_to :course_node

  # Texto rico (ActionText) — suporta imagens e vídeos uploadados
  has_rich_text :content
  enum :submission_type, { none: 0, text: 1, file: 2, link: 3 }, prefix: true

  validates :title, presence: true
end