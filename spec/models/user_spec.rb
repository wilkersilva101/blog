require 'rails_helper'

RSpec.describe User, type: :model do
  # Testando validações
  it { should validate_presence_of(:name) }

  # Testando associações
  it { should have_many(:articles).dependent(:destroy) }

  # Testando métodos de instância
  describe '#admin?' do
    let(:user) { User.new }

    it 'retorna true se o usuário tem o papel admin' do
      allow(user).to receive_message_chain(:roles, :exists?).with(name: 'admin').and_return(true)
      expect(user.admin?).to be true
    end

    it 'retorna false se o usuário não tem o papel admin' do
      allow(user).to receive_message_chain(:roles, :exists?).with(name: 'admin').and_return(false)
      expect(user.admin?).to be false
    end
  end

  describe '#has_role?' do
    let(:user) { User.new }

    it 'verifica se o usuário tem um papel específico' do
      allow(user).to receive_message_chain(:roles, :exists?).with(name: 'editor').and_return(true)
      expect(user.has_role?('editor')).to be true
    end

    it 'retorna false se o usuário não tem o papel específico' do
      allow(user).to receive_message_chain(:roles, :exists?).with(name: 'editor').and_return(false)
      expect(user.has_role?('editor')).to be false
    end
  end

  describe '#read_and_write?' do
    let(:user) { User.new }

    it 'retorna true se o usuário tem o papel read_and_write' do
      allow(user).to receive_message_chain(:roles, :exists?).with(name: 'read_and_write').and_return(true)
      expect(user.read_and_write?).to be true
    end

    it 'retorna false se o usuário não tem o papel read_and_write' do
      allow(user).to receive_message_chain(:roles, :exists?).with(name: 'read_and_write').and_return(false)
      expect(user.read_and_write?).to be false
    end
  end

  describe '#read_only?' do
    let(:user) { User.new }

    it 'retorna true se o usuário tem o papel read_only' do
      allow(user).to receive_message_chain(:roles, :exists?).with(name: 'read_only').and_return(true)
      expect(user.read_only?).to be true
    end

    it 'retorna false se o usuário não tem o papel read_only' do
      allow(user).to receive_message_chain(:roles, :exists?).with(name: 'read_only').and_return(false)
      expect(user.read_only?).to be false
    end
  end
end
