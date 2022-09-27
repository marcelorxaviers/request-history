# frozen_string_literal: true

require_relative '../test_helper'

# Although it tests the test controller, we are actually checking for the recording module
# specifics.
#
# We use the TestsController because it is tailored for recording tests and then we can use the
# @controller variable for our assertions
class TestsControllerTest < ActionController::TestCase
  test 'asserts that recording module is included into test_controller' do
    assert TestsController.include?(Request::History::Recording)
  end

  test 'asserts that recording module inclusion creates storages class method' do
    assert TestsController.respond_to?(:storages)
    assert TestsController.storages.include?(Request::History::IOStorage)
  end

  test 'asserts that recording module inclusion creates parameters_to_record class method' do
    assert TestsController.respond_to?(:parameters_to_record)
    assert TestsController.parameters_to_record.include?(:say)
  end

  test 'asserts that tests controller is responding to index action' do
    get :index

    assert_equal '{"some":"thing"}', response.body
  end

  test 'asserts that record method is called after request fulfillment' do
    mocked_record_method = MiniTest::Mock.new
    mocked_record_method.expect :call, nil, []
    @controller.stub(:record, mocked_record_method) do
      get :index
    end

    mocked_record_method.verify
  end
end
