class ReportsController < ApplicationController
#   def balance
#     redirect_to root_path, notice: 'Não implementado'
#   end
# end

  def balance
    UserMailer.balance_report_email(current_user).deliver_now
    redirect_to root_path, notice: 'Você receberá um email com os relatórios'
  end
end
