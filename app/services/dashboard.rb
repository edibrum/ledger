class Dashboard
  def initialize(user)
    @user = user
  end

  # ANTES NO CONTROLER: @my_people = Person.where(user: current_user).order(:created_at).limit(10)
  def my_people #IMPORTANTE - não "cachear o MY_PEOPLE" - por questão de segurança!!! poderia não expor dado do último usuário logado!!!
    Person.where(user: @user).order(:created_at).limit(10)
  end

  # ANTES NO CONTROLER: @top_person = Person.order(:balance).last
  def top_person 
    Rails.cache.fetch('top_person', expires_in: 2.hours) do
      Person.order(:balance).last
    end
  end

  # ANTES NO CONTROLER: @bottom_person = Person.order(:balance).first
  def bottom_person 
    Rails.cache.fetch('bottom_person', expires_in: 2.hours) do
      Person.order(:balance).first
    end
  end

  # ANTES NO CONTROLER: @active_people_pie_chart = {
  #     active: Person.where(active: true).count,
  #     inactive: Person.where(active: false).count
  #   }
  def active_people_pie_chart
    Rails.cache.fetch('active_people_pie_chart', expires_in: 2.hours) do
    {
       active: Person.where(active: true).count,
       inactive: Person.where(active: false).count
     }
    end
  end

  # ANTES NO CONTROLER: active_people_ids = Person.where(active: true).select(:id)
  def active_people_ids 
    Rails.cache.fetch('active_people_ids', expires_in: 2.hours) do
    Person.where(active: true).select(:id)
    end
  end

  # ANTES NO CONTROLER: @total_debts = Debt.where(person_id: active_people_ids).sum(:amount)
  def total_debts 
    Rails.cache.fetch('total_debts', expires_in: 2.hours) do
    Debt.where(person_id: active_people_ids).sum(:amount)
    end
  end

  # ANTES NO CONTROLER: @total_payments = Payment.where(person_id: active_people_ids).sum(:amount)
  def total_payments
    Rails.cache.fetch('total_payments', expires_in: 2.hours) do
      Payment.where(person_id: active_people_ids).sum(:amount)
    end
  end

  # ANTES NO CONTROLER: @balance = @total_payments - @total_debts
  def balance 
    Rails.cache.fetch('balance', expires_in: 2.hours) do
    total_payments - total_debts
    end
  end

  # ANTES NO CONTROLER: @last_debts = Debt.order(created_at: :desc).limit(10).map do |debt|
  #     [debt.id, debt.amount]
  #   end
  def last_debts 
    Rails.cache.fetch('last_debts', expires_in: 2.hours) do
      Debt.order(created_at: :desc).limit(10).map do
        |debt|
        [debt.id, debt.amount]
      end
    end
  end

  # ANTES NO CONTROLER: @last_payments = Payment.order(created_at: :desc).limit(10).map do |payment|
  #     [payment.id, payment.amount]
  #   end
  def last_payments 
    Rails.cache.fetch('last_payments', expires_in: 2.hours) do
      Payment.order(created_at: :desc).limit(10).map do
      |payment|
      [payment.id, payment.amount]
      end
    end
  end

end