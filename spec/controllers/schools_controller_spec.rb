require 'spec_helper'

describe SchoolsController, '#index' do
  it 'should assign to schools' do
    get :index
    
    should assign_to :schools
  end
end