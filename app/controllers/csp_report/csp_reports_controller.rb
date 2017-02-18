require_dependency "csp_report/application_controller"

class CspReport::CspReportsController < ApplicationController
  # The browser submitting the report will not have any CSRF token
  skip_before_filter :verify_authenticity_token
  layout "csp_report/application"

  def index
    @reports = CspReport::CspReport.all
  end

  def create
    param = JSON.parse(request.body.read)['csp-report']
    report = CspReport::CspReport.new do |r|
      r.document_uri = param['document-uri']
      r.referrer = param['referrer']
      r.violated_directive = param['violated-directive']
      r.original_policy = param['original-policy']
      r.blocked_uri = param['blocked-uri']
      r.incoming_ip = request.remote_ip
    end
    report.save!
    render status: 200, nothing: true
  end

  def destroy
    CspReport::CspReport.find(params[:id]).destroy
    redirect_to csp_reports_path
  end

  def destroy_all
    CspReport::CspReport.delete_all
    redirect_to csp_reports_path
  end

  def report_by_ip
    @report_by_ip = CspReport::CspReport.pluck(:incoming_ip).group_by{ |ip| ip }.map{ |ip, reports| 
      OpenStruct.new(incoming_ip: ip, count: reports.count) 
    }

    data = []
    for report in @report_by_ip
      data.push [report.incoming_ip, report.count]
    end

    @chart = {
      chart: {
        :defaultSeriesType=>"pie" ,
        :margin=> [50, 200, 60, 170]
      },
      series: [{
        :type=> 'pie',
        :name=> 'Violations by client IP',
        :data=> data
      }],
      title: {text:  "By IP"},
      legend: {
        :layout=> 'vertical',
        :style=> {
          :left=> 'auto',
          :bottom=> 'auto',
          :right=> '50px',
          :top=> '100px'
        }
      },
      plotOptions: {
        :pie=>{
          :allowPointSelect=>true,
          :cursor=>"pointer" ,
          :dataLabels=>{
            :enabled=>true,
            :color=>"black",
            :style=>{
              :font=>"13px Trebuchet MS, Verdana, sans-serif"
            }
          }
        }
      }
    }
  end

  def report_by_rule
    @report_by_rule = CspReport::CspReport.pluck(:violated_directive).group_by{ |d| d }.map{ |d, reports| 
      OpenStruct.new(violated_directive: d, count: reports.count) 
    }

    data = []
    for report in @report_by_rule
      data.push [report.violated_directive, report.count]
    end

    @chart = {
      chart: {
        :defaultSeriesType=>"pie" ,
        :margin=> [50, 200, 60, 170]
      },
      series: [{
        :type=> 'pie',
        :name=> 'Violations by violated policy',
        :data=> data
      }],
      title: {text:  "By rule"},
      legend: {
        :layout=> 'vertical',
        :style=> {
          :left=> 'auto',
          :bottom=> 'auto',
          :right=> '50px',
          :top=> '100px'
        }
      },
      plotOptions: {
        :pie=>{
          :allowPointSelect=>true,
          :cursor=>"pointer" ,
          :dataLabels=>{
            :enabled=>true,
            :color=>"black",
            :style=>{
              :font=>"13px Trebuchet MS, Verdana, sans-serif"
            }
          }
        }
      }
    }
  end

  def report_by_source
    @report_by_source = CspReport::CspReport.pluck(:document_uri).group_by{ |uri| uri }.map{ |uri, reports| 
      OpenStruct.new(document_uri: uri, count: reports.count) 
    }

    data = []
    for report in @report_by_source
      data.push [report.document_uri, report.count]
    end

    @chart = {
      chart: {
        :defaultSeriesType=>"pie" ,
        :margin=> [50, 200, 60, 170]
      },
      series: [{
        :type=> 'pie',
        :name=> 'Violations by source document URI',
        :data=> data
      }],
      title: {text:  "By source"},
      legend: {
        :layout=> 'vertical',
        :style=> {
          :left=> 'auto',
          :bottom=> 'auto',
          :right=> '50px',
          :top=> '100px'
        }
      },
      plotOptions: {
        :pie=>{
          :allowPointSelect=>true,
          :cursor=>"pointer" ,
          :dataLabels=>{
            :enabled=>true,
            :color=>"black",
            :style=>{
              :font=>"13px Trebuchet MS, Verdana, sans-serif"
            }
          }
        }
      }
    }
  end
end
