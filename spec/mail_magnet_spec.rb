require 'spec_helper'

describe 'mail_magnet' do

  before :each do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.override_recipients = nil
  end

  it 'should allow to override recipients, cc and bcc for all mailers' do
    ActionMailer::Base.override_recipients = 'overridden.to@example.com'
    Mailer.deliver_letter
    ActionMailer::Base.deliveries.last.to.should == ['overridden.to@example.com']
    ActionMailer::Base.deliveries.last.cc.should == ['overridden.to@example.com']
    ActionMailer::Base.deliveries.last.bcc.should == ['overridden.to@example.com']
  end

  it 'should allow to override recipients, cc, and bcc with multiple recipients' do
    overrides = %w[ overridden.to@example.com other.overridden.to@example.com ]
    ActionMailer::Base.override_recipients = overrides
    Mailer.deliver_letter
    ActionMailer::Base.deliveries.last.to.should == overrides
    ActionMailer::Base.deliveries.last.cc.should == overrides
    ActionMailer::Base.deliveries.last.bcc.should == overrides
  end

  it 'should allow a proc as the override recipients' do
    overrides = lambda{|m| %w[ overridden.to@example.com] }
    ActionMailer::Base.override_recipients = overrides
    Mailer.deliver_letter
    ActionMailer::Base.deliveries.last.to.should == %w[ overridden.to@example.com]
    ActionMailer::Base.deliveries.last.cc.should == %w[ overridden.to@example.com]
    ActionMailer::Base.deliveries.last.bcc.should ==%w[ overridden.to@example.com]
  end

  it 'should leave original recipients untouched if it is not activated' do
    Mailer.deliver_letter
    ActionMailer::Base.deliveries.last.to.should == ['original.to@example.com']
    ActionMailer::Base.deliveries.last.cc.should == ['original.cc@example.com']
    ActionMailer::Base.deliveries.last.bcc.should == ['original.bcc@example.com']
  end

  it 'should not touch the subject' do
    ActionMailer::Base.override_recipients = 'overridden.to@example.com'
    Mailer.deliver_letter
    ActionMailer::Base.deliveries.last.subject.should == 'Hello Universe!'
  end
  
  it 'should detect the content_type correctly' do
    ActionMailer::Base.override_recipients = 'overridden.to@example.com'
    Mailer.deliver_letter
    ActionMailer::Base.deliveries.last.content_type.should == "text/plain"
    Mailer.deliver_html_letter
    ActionMailer::Base.deliveries.last.content_type.should include("text/html") # content_type sometimes ends with "; charset=utf-8"
  end

end
