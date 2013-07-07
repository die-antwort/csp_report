require 'spec_helper'

describe CspReport::CspReport do
  before(:each) do
    @unsaved_report = {
      'document_uri' => "http://localhost:3000/home/index",
      'referrer' => "",
      'blocked_uri' => "",
      'violated_directive' => "script-src 'self'",
      'original_policy' => "script-src 'self'; report_uri /csp/csp_reports"
    }

    @unsaved_report_wout_document_uri = {
      'referrer' => "",
      'blocked_uri' => "",
      'violated_directive' => "script-src 'self'",
      'original_policy' => "script-src 'self'; report_uri /csp/csp_reports"
    }

    @unsaved_report_wout_violated_directive = {
      'document_uri' => "http://localhost:3000/home/index",
      'referrer' => "",
      'blocked_uri' => "",
      'original_policy' => "script-src 'self'; report_uri /csp/csp_reports"
    }

    @unsaved_report_wout_original_policy = {
      'document_uri' => "http://localhost:3000/home/index",
      'referrer' => "",
      'blocked_uri' => "",
      'violated_directive' => "script-src 'self'",
    }

  end

  describe "pure model" do
    it "should create a rew report when all the mandatory attributes are provided" do
      report = CspReport::CspReport.new(@unsaved_report)
      assert_not_nil report
    end

    it "should fail to create a report when the document_uri is missing" do
      report = CspReport::CspReport.new(@unsaved_report_wout_document_uri)
      assert_nil report
    end

    it "should fail to create a report when the violated_directive is missing" do
      report = CspReport::CspReport.new(@unsaved_report_wout_violated_directive)
      assert_nil report
    end

    it "should fail to create a report when the original_policy is missing" do
      report = CspReport::CspReport.new(@unsaved_report_wout_original_policy)
      assert_nil report
    end
  end

  describe "active_record" do
    it "should save to the database when all the mandatory attributes are provided" do
      report = CspReport::CspReport.new(@unsaved_report)
      expect {
        report.save!
      }.to change(CspReport::CspReport, :count).by(1)
    end

    it "should fail to save to the db when the document_uri is missing" do
      report = CspReport::CspReport.new(@unsaved_report_wout_document_uri)
      # TODO: gbataille - find an assert statement to test the failure.
      # this works though
      begin
        report.save
      rescue
      end
      assert_equal 0, CspReport::CspReport.count
    end

    it "should fail to save to the db when the violated_directive is missing" do
      report = CspReport::CspReport.new(@unsaved_report_wout_violated_directive)
      # TODO: gbataille - find an assert statement to test the failure.
      # this works though
      begin
        report.save
      rescue
      end
      assert_equal 0, CspReport::CspReport.count
    end

    it "should fail to save to the db when the original_policy is missing" do
      report = CspReport::CspReport.new(@unsaved_report_wout_original_policy)
      # TODO: gbataille - find an assert statement to test the failure.
      # this works though
      begin
        report.save
      rescue
      end
      assert_equal 0, CspReport::CspReport.count
    end
  end
end
