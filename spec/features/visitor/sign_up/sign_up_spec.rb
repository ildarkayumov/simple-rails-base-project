require 'rails_helper'

feature 'Sign up' do
  let(:user) { User.first }

  let(:sign_up_page) { Devise::Registrations::New.new }
  let(:resend_confirmation_page) { Devise::Confirmations::New.new }

  before(:each) do
    sign_up_page.load
    sign_up_page.register
  end

  scenario 'User signs up successfully' do
    open_email(user.email)

    expect(current_email).to have_subject 'Confirmation instructions'
    expect(current_email).to have_body_text(user.full_name)
  end

  scenario 'User confirms account' do
    open_email(user.email)
    visit_in_email 'Confirm my account'

    expect(user.reload).to be_confirmed
  end

  scenario 'User resents email confirmation instructions' do
    resend_confirmation_page.load
    resend_confirmation_page.submit_form(user.email)

    open_email(user.email)

    expect(current_email).to have_subject 'Confirmation instructions'
    expect(current_email).to have_body_text(user.full_name)
  end
end
