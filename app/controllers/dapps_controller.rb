class DappsController < ApplicationController

  def index
    options = get_options

    @banners = Banner.ransack(options).result
    # @dapps = Dapp.all.group_by { |dapp| dapp.d_type }
    @dapps = DappType.default_order.map do |dapp_type|
      { dapp_type.name => dapp_type.dapps.default_order.ransack(options).result.limit(3) }
    end.reduce({}, :merge).reject {|k, v| v.empty?}
  end

  # GET /dapps/:id
  def show
    @dapp = Dapp.find_by(id: params[:id])
    @start_at = @dapp.start_at.to_s.split(' ')[0]
    @star = @dapp.score
    if @star < 0
      @star = 0
    elsif @star > 5
      @star = 5
    end
    @stargray = 5 - @star
  end

  # GET /dapp/more/:type_name
  def more
    options = get_options

    @dapp_type = DappType.find_by name: params[:type_name]
    @dapps = @dapp_type.dapps.default_order.ransack(options).result
  end

  def mine
  end

  def history
  end

  private

  def handle_version(version)
    return if version.blank?
    Dapp.handle_version(version)
  end

  def get_options
    now = Time.now
    opt = {
      start_at_lteq: now,
      end_at_gteq: now,
      ios_version_number_lteq: handle_version(params[:ios_version]),
      android_version_number_lteq: handle_version(params[:android_version]),
    }

    if FilterIpUtils.china_mainland?(request.remote_ip)
      opt.merge!(filter_ip_eq: false)
    end

    opt
  end

end
