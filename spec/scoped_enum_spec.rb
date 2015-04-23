require 'spec_helper'

describe ScopedEnum do
  it 'has a version number' do
    expect(ScopedEnum::VERSION).not_to be nil
  end

  describe '.scoped_enum' do
    let!(:normal) { create(:user) }
    let!(:administrator) { create(:administrator) }
    let!(:superuser) { create(:superuser) }

    context 'valid scope' do
      it 'creates a class scope from the scope hash and the block' do
        expect(User.managers).to contain_exactly(administrator, superuser)
        expect(User.non_admins).to contain_exactly(normal, superuser)
      end

      it 'creates a checking instance method' do
        expect(normal.manager?).to be_falsey
        expect(administrator.manager?).to be_truthy
        expect(superuser.manager?).to be_truthy
      end

      it 'creates a hash of all scopes for an enum' do
        expect(User.role_scopes).to include(manager: { administrator: 1, superuser: 2 })
        expect(User.role_scopes).to include(non_admin: { normal: 0, superuser: 2 })
      end
    end

    context 'invalid scope' do
      it 'raises error when scopes have conflicting names' do
        expect do
          User.send(:scoped_enum,
                    :responsibility1,
                    { teach1: 0, manage1: 1, both1: 2 },
                    { manager: [:manage, :both] })
        end.to raise_error("Conflicting scope names. A scope named manager has already been defined")
      end

      it 'raises error when a scope contains unknown enum key' do
        expect do
          User.send(:scoped_enum,
                    :responsibility2,
                    { teach2: 0, manage2: 1, both2: 2 },
                    { manager2: [:manage2, :no_such_key] })
        end.to raise_error("Unknown key - no_such_key for enum responsibility2")
      end

      it 'raises error when a scope has a conflicting name with some other class method' do
        expect do
          User.send(:scoped_enum,
                    :responsibility3,
                    { teach3: 0, manage3: 1, both3: 2 },
                    { non_superuser: [:teach3, :manage3] })
        end.to raise_error("Scope name - non_superuser conflicts with a class method of the same name")
      end

      it 'raises error when scopes have conflicting names' do
        expect do
          User.send(:scoped_enum,
                    :responsibility4,
                    { teach4: 0, manage4: 1, both4: 2 },
                    { higher_position: [:manage4, :both4] })
        end.to raise_error("Scope name - higher_position conflicts with the instance method - higher_position?")
      end
    end
  end
end
