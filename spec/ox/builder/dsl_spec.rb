require 'spec_helper'

describe Ox::Builder::DSL do
  it 'should return \n when no block is given' do
    expect(generate).to eq("\n")
  end

  describe '#instruct!' do
    it 'should create a default processing instruction' do
      doc = generate { instruct! }
      expect(doc.strip).to eq('<?xml version="1.0" encoding="UTF-8"?>')
    end

    it 'should allow the instruct! attributes to be changed' do
      doc = generate { instruct! version: 2.0 }
      expect(doc.strip).to eq('<?xml version="2.0"?>')
    end

    it 'should allow the instruct! command to specify a different name' do
      doc = generate { instruct! 'xml-stylesheet', type: 'text/xsl', href: 'style.xsl' }
      expect(doc.strip).to eq('<?xml-stylesheet type="text/xsl" href="style.xsl"?>')
    end
  end

  describe '#tag!' do
    it 'should create an empty tag if no content and no block is given' do
      doc = generate { tag! :person }
      expect(doc.strip).to eq('<person/>')
    end

    it 'should create an empty tag if no content or block is given when using dynamic tags' do
      doc = generate { person }
      expect(doc.strip).to eq('<person/>')
    end

    it 'should allow a tag to have attributes and content' do
      doc = generate { tag! :person, 'John Smith', id: '123' }
      expect(doc.strip).to eq('<person id="123">John Smith</person>')
    end

    it 'should allow tag names to be specified with a ! if they would otherwise conflict' do
      def name
        'John Smith'
      end

      doc = generate { name! name }
      expect(doc.strip).to eq('<name>John Smith</name>')
    end

    it 'should allow tags to be created dynamically' do
      def get_name
        :quux
      end

      doc = generate { foobarbaz get_name }
      expect(doc.strip).to eq('<foobarbaz>quux</foobarbaz>')
    end

    it 'should allow methods to be accessed from a subnode' do
      def get_name
        'John Smith'
      end

      doc = generate do
        data do
          name get_name
        end
      end

      expect(doc).to eq(load_xml('method-in-subnode'))
    end

    it 'should call the correct method when the context has a method that conflicts with the DSL' do
      def tag!(*)
        raise
      end

      doc = generate do
        tag! :name
      end

      expect(doc.strip).to eq('<name/>')
    end
  end

  describe '#cdata!' do
    it 'should wrap text in CDATA in a tag' do
      doc = generate { name { cdata!('John Smith') } }
      expect(doc).to eq(load_xml(:cdata))
    end

    it 'should not output CDATA directly' do
      doc = generate { cdata! 'John Smith' }
      expect(doc.strip).to eq('<![CDATA[John Smith]]>')
    end

    it 'should allow a tag to have attributes and cdata at the same time' do
      doc = generate do
        name for: 'me' do
          cdata!('John Smith')
        end
      end

      expect(doc).to eq(load_xml('cdata-with-attrs'))
    end
  end

  describe '#comment!' do
    it 'should allow comments to be created' do
      doc = generate { comment! 'this is my comment' }
      expect(doc.strip).to eq('<!-- this is my comment -->')
    end
  end

  describe '#doctype!' do
    it 'should allow doctypes to be created' do
      doc = generate { doctype! :html }
      expect(doc.strip).to eq('<!DOCTYPE html >')
    end
  end
end
