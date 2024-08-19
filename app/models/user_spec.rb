require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_password) { 'Password1' }
  let(:invalid_password) { 'pass' }
  let(:user) { User.new(email: 'test@example.com', password: valid_password) }

  describe 'validações' do
    it 'é válido com um email e uma senha válidos' do
      expect(user).to be_valid
    end

    it 'não é válido sem um email' do
      user.email = nil
      expect(user).to_not be_valid
    end

    it 'não é válido sem uma senha' do
      user.password = nil
      expect(user).to_not be_valid
    end

    it 'não é válido se o email já está em uso' do
      user.save
      duplicate_user = User.new(email: user.email, password: valid_password)
      expect(duplicate_user).to_not be_valid
    end

    it 'não é válido se a senha for muito curta' do
      user.password = invalid_password
      expect(user).to_not be_valid
    end

    it 'não é válido se a senha não tiver pelo menos uma letra e um dígito' do
      user.password = '12345678'
      expect(user).to_not be_valid
    end
  end

  describe 'funcionalidade de autenticação' do
    it 'autentica com a senha correta' do
      user.save
      expect(user.authenticate(valid_password)).to be_truthy
    end

    it 'não autentica com uma senha incorreta' do
      user.save
      expect(user.authenticate('wrongpassword')).to be_falsey
    end
  end

  describe 'autorização' do
    it 'verifica se o usuário é administrador' do
      user.role = 'admin'
      expect(user.admin?).to be_truthy
    end

    it 'verifica se o usuário não é administrador' do
      user.role = 'user'
      expect(user.admin?).to be_falsey
    end
  end

  describe 'geração de token de autenticação' do
    it 'gera um token de autenticação único' do
      user.save
      token = user.generate_auth_token
      expect(user.auth_token).to eq(token)
      expect(token).to_not be_nil
    end
  end

  describe 'reset de senha' do
    it 'reseta a senha do usuário' do
      user.save
      new_password = 'Newpassword1'
      user.reset_password(new_password)
      expect(user.authenticate(new_password)).to be_truthy
    end
  end
end
