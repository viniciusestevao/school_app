module RichContentHelper
  YT_REGEX = %r{\Ahttps?://(www\.)?(youtube\.com/watch\?v=|youtu\.be/)([\w\-]+)}i
  VIMEO_REGEX = %r{\Ahttps?://(www\.)?vimeo\.com/(\d+)}i

  def rich_render(content)
    html = content.to_s

    # substitui links por embeds
    doc = Nokogiri::HTML::DocumentFragment.parse(html)
    doc.css('a').each do |a|
      href = a['href'].to_s
      if href =~ YT_REGEX
        video_id = href.split(/v=|youtu\.be\//).last
        a.replace youtube_iframe(video_id)
      elsif href =~ VIMEO_REGEX
        video_id = href.split('/').last
        a.replace vimeo_iframe(video_id)
      end
    end

    doc.to_html.html_safe
  end

  private

  def youtube_iframe(id)
    <<~HTML
      <div class="ratio ratio-16x9 my-3">
        <iframe src="https://www.youtube.com/embed/#{ERB::Util.html_escape(id)}"
                title="YouTube video"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                allowfullscreen loading="lazy"></iframe>
      </div>
    HTML
  end

  def vimeo_iframe(id)
    <<~HTML
      <div class="ratio ratio-16x9 my-3">
        <iframe src="https://player.vimeo.com/video/#{ERB::Util.html_escape(id)}"
                title="Vimeo video" allow="autoplay; fullscreen; picture-in-picture"
                allowfullscreen loading="lazy"></iframe>
      </div>
    HTML
  end
end
