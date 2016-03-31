require 'spec_helper'

describe Ox::Builder::ActionView::TemplateHandler do
  it 'should add the ox template handler' do
    expect(ActionView::Template.template_handler_extensions).to include('ox')
  end

  it 'should allow ActionView to render Ox::Builder templates' do
    v = ActionView::Base.new
    doc = v.render file: 'spec/support/test', handlers: [:ox]
    expect(doc).to eq(load_xml(:test))
  end
end
