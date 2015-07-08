module ApplicationHelper
  def icon_thumb(account)
    icon(account, version: :thumb, class: 'thumb')
  end

  def icon(account, opt)
    opt[:class] ||= ''
    opt[:class] << ' account_icon img-rounded'
    opt[:data] = {toggle: "tooltip", placement: "top"}
    opt[:title] = account.name
    if account.icon_url
      image_tag account.icon_url, opt
    else
      fa(:user, opt)
    end
  end

  def inline_icon(account, opt={})
    opt[:class] ||= ''
    opt[:class] << ' account_icon inline-icon img-circle'
    if account.icon_url
      opt.merge!({
        style: "background-image: url('#{account.icon_url}');",
      })
    else
      opt[:class] << ' fa fa-user'
    end
    content_tag(:span, nil, opt)
  end

  def fa(type, opts={})
    cs = ["fa", "fa-#{type}", "text-center"]
    opts[:class] = [opts[:class], cs].flatten.compact.uniq
    content_tag :span, nil, opts.merge({aria:{hidden:'true'}})
  end

  def proxy_url(tori_file, *args)
    case Tori.config.backend
    when Tori::Backend::FileSystem
      src = "localhost:3000/tori/#{tori_file.name}"
      "#{Rails.application.config.kanoko_host}#{Kanoko.path_for(*args, src)}"
    when Tori::Backend::S3
      src = tori_file.public_url.to_s.sub(%r{https?://}, '')
      "#{Rails.application.config.kanoko_host}#{Kanoko.path_for(*args, src)}"
    end
  end
end
