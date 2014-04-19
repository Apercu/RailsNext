class Contact < MailForm::Base
    attribute :login, :validate => true
    attribute :email, :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
    attribute :message
    attribute :nickname, :captcha => true

    def headers
    {
        :subject => "[Contact] RubyProject",
        :to => "bgronon@gmail.com",
        :from => %("#{login}" <#{email}>)
    }
    end
end
