require 'set'

shared_examples 'a company page' do 
  it { should have_selector('title', text: @company.name) }
  it { should have_selector('h1', text: @company.name) }
  it { should have_content(@company.address) }
  it { should have_content(@company.description) }
end
