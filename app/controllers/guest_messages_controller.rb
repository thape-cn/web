class GuestMessagesController < ApplicationController
  def create
    GuestMessage.create(guest_param)
  end

  private

  def guest_param
    params.require(:guest)
      .permit(:message, :name, :company, :contact_details)
  end
end
