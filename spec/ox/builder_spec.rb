require 'spec_helper'

SIMPLE_XML = <<-xml
<?xml version="1.0" encoding="UTF-8"?>
<name for="creator">
  <![CDATA[John]]>
</name>
<data>
  <foo>bar</foo>
</data>
xml

XML = <<-xml
<?xml version="1.0" encoding="UTF-8"?>
<data>
  <provider>
    <![CDATA[Data-Provider]]>
  </provider>
  <provided_at>Sun, 10 Apr 2016 00:00:00 GMT</provided_at>
  <shapes>
    <shape>
      <type>
        <![CDATA[rectangle]]>
      </type>
      <width>30</width>
      <height>15</height>
      <color>
        <![CDATA[]]>
      </color>
    </shape>
    <shape>
      <type>
        <![CDATA[square]]>
      </type>
      <width>20</width>
      <height>20</height>
      <color>
        <![CDATA[#CCCCCC]]>
      </color>
    </shape>
  </shapes>
</data>
xml

Shape = Struct.new(:type, :width, :height, :color)

describe Ox::Builder do
  before { @shapes = [ Shape.new(:rectangle, 30, 15), Shape.new(:square, 20, 20, '#CCCCCC') ] }

  it 'should build a simple document' do
    doc = Ox::Builder.build do
      instruct!
      tag! :name, cdata!('John'), for: 'creator'
      tag! :data do
        tag! :foo, :bar
      end
    end

    expect(doc.to_s).to eq(SIMPLE_XML)
  end

  it 'should build a simple document using a block param' do
    doc = Ox::Builder.build do |xml|
      xml.instruct!
      xml.tag! :name, xml.cdata!('John'), for: 'creator'
      xml.tag! :data do |xml|
        xml.tag! :foo, :bar
      end
    end

    expect(doc.to_s).to eq(SIMPLE_XML)
  end

  it 'should allow tags to be created dynamically' do
    def get_name
      :quux
    end

    doc = Ox::Builder.build do |xml|
      foobarbaz get_name
    end

    expect(doc.to_s.strip).to eq('<foobarbaz>quux</foobarbaz>')
  end

  it 'should build an XML document' do
    doc = Ox::Builder.build do |xml|
      xml.instruct!
      xml.data do |xml|
        xml.provider xml.cdata!('Data-Provider')
        xml.provided_at Date.new(2016, 4, 10).strftime('%a, %e %b %Y %H:%M:%S GMT')

        xml.shapes do |xml|
          @shapes.each do |shape|
            xml.shape do |xml|
              xml.type xml.cdata!(shape.type)
              xml.width shape.width
              xml.height shape.height
              xml.color xml.cdata!(shape.color)
            end
          end
        end
      end
    end

    expect(doc.to_s).to eq(XML)
  end

  it 'should build an XML document without block params' do
    doc = Ox::Builder.build do
      instruct!
      data do
        provider cdata!('Data-Provider')
        provided_at Date.new(2016, 4, 10).strftime('%a, %e %b %Y %H:%M:%S GMT')

        shapes do
          @shapes.each do |s|
            shape do
              type cdata!(s.type)
              width s.width
              height s.height
              color cdata!(s.color)
            end
          end
        end
      end
    end

    expect(doc.to_s).to eq(XML)
  end

  it 'should allow tag names to be specified with a ! if they would otherwise conflict' do
    def name
      'John Smith'
    end

    doc = Ox::Builder.build do
      name! name
    end

    expect(doc.to_s.strip).to eq('<name>John Smith</name>')
  end
end
