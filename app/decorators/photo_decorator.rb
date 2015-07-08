module PhotoDecorator
  def meta_tag
    Imagine.new(StringIO.new(original_header)).to_h.merge({
      filename: filename,
      size: number_to_human_size(size),
      shot_at: shot_at,
    }).map { |k, v|
      case k
      when :width, :height
        [I18n.t("views.imagine.#{k}"), "#{v}px"]
      else
        [I18n.t("views.imagine.#{k}"), tag_value(v)]
      end
    }.to_h.to_yaml if original_header
  end

  def owner?
    current_account.try(:id) == account_id
  end

  private

    def tag_value(v)
      case v
      when EXIFR::TIFF::Orientation
        {'value' => v.to_i, 'type' => v.to_sym}
      when Rational
        v.to_s
      else
        v
      end
    end
end
