require 'csv'
class UserMailer < ApplicationMailer

default from: 'no_reply@example.com'
 
  def balance_report_email(user)
    @UserFirstPersonName = user.people.first.name if user.people.any? #vamos usar o nome do primeiro registro vinculado ao usuario logado
    @people = Person.order(:name) #aqui teremos a lista de todas as pessoas

     csv_content = generate_csv() # aqui geramos o conteúdo CSV

     attachments['balance_report.csv'] = { mime_type: 'text/csv', content: csv_content } # aqui anexamos o arquivo CSV ao e-mail

    mail(to: user.email, subject: 'Relatorio _ Teste Aplicacao Ledger', attachments: attachments) # aqui enviamos o email com o anexo
  end


  private def generate_csv()
    CSV.generate(headers: true) do |csv|

      csv << ['Nome', 'Saldo'] # o cabeçalho do arquivo

      @people.each do |person| 
        csv << [person.name, person.balance] # as linhas com os dados de cada pessoa
      end
      
    end
  end


end
