ActionMailer::Base.class_eval do

  @@override_recipients = nil
  cattr_accessor :override_recipients

  def deliver_with_override!(mail = @mail)
    override_recips = override_recipients.respond_to?(:call) ? override_recipients.call(mail) : override_recipients
    if override_recips.present?
      mail.override_recipients! override_recips
    end
    deliver_without_override! mail
  end
  alias_method_chain :deliver!, :override

end
