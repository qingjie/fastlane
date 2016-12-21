
# Customise this file, documentation can be found here:
# https://github.com/fastlane/fastlane/tree/master/docs
# All available actions: https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Actions.md
# can also be listed using the `fastlane actions` command

# Change the syntax highlighting to Ruby
# All lines starting with a # are ignored when running `fastlane`

# If you want to automatically update fastlane if a new version is available:
# update_fastlane

# This is the minimum version number required.
# Update this, if you use features of a newer version
fastlane_version "1.89.0"

default_platform :ios


platform :ios do
  before_all do
    # ENV["SLACK_URL"] = "https://hooks.slack.com/services/..."
  end
  
  
  #fastlane with parameters
  #if SubmitToAppleReview is true, need people to submit; else automatically submit to appstore.
  #type is library or standalone.
  #if appIds is empty, it will build all.
  #for example: fastlane appstore submitToAppleReview:true type:standalone appIds:2492,2493
  
  lane :appstore do |options|
  	bln_s = false;
  	bln_l = false
		array = Array.new
		if (options[:submitToAppleReview])
			sh 'cp ./fetch_data/common/Deliverfile .'
	  	end
		
		strType = String.new
		strType = options[:type]

		library_scheme_name = String.new

		#array = Array.new
		if (options[:appIds].to_s.strip.length == 0)
			puts "----appIds is nil, empty, or just whitespace"
			if (strType == "standalone")
				#sh 'rm -rf  ./../targets/standalone'
				sh 'cd fetch_data && ./grabName.sh standalone all name'
				line_num=0
				text=File.open('../../sh/temp-all.txt').read
				text.gsub!(/\r\n?/, "\n")
				text.each_line do |line|
  					array.push("#{line}".strip)
				end
				sh 'cd ../../sh && rm -rf temp-all.txt'
			else
				#sh 'rm -rf  ./../targets/library'
				sh 'cd fetch_data && ./grabName.sh library all name'
				line_num=0
				text=File.open('../../sh/temp-all.txt').read
				text.gsub!(/\r\n?/, "\n")
				text.each_line do |line|
  					array.push("#{line}".strip)
				end
				sh 'cd ../../sh && rm -rf temp-all.txt'
			end
			bln_s = true
			bln_l = true
		else
			puts "----appIds is not nil, empty, or just whitespace"
			array = options[:appIds].split(",")
			if (strType == "standalone")
				bln_s = array.include? '2492'
				array.unshift('2492')
			else
				bln_l = array.include? '0000'
				array.unshift('0000')
			end
			puts array.inspect
		end
		

		array = array.uniq
		#puts array
		array.each do |scheme_name|

			ENV["SCHEME"] = scheme_name
		 	
			if (strType == "standalone")
				sh 'cd fetch_data && ./grabData.sh standalone "$SCHEME"' 
				sh 'cd ../../sh &&  ./create-standalone.sh "$SCHEME"'
				
				if ( !bln_s && scheme_name != "2492" )
					sh 'cd ../../sh && ./buildAndArchive-prod-fastlane.sh "$SCHEME" nobumpbuild standalone'
				elsif( bln_s )
					sh 'cd ../../sh && ./buildAndArchive-prod-fastlane.sh "$SCHEME" nobumpbuild standalone'
				end
				
			else
		 		sh 'cd fetch_data && ./grabData.sh library "$SCHEME"'
				sh 'cd ../../sh &&  ./create-library.sh "$SCHEME"'
				if ( !bln_l && scheme_name != "0000" )
					sh 'cd ../../sh && ./buildAndArchive-prod-fastlane.sh "$SCHEME" nobumpbuild library'
				elsif ( bln_l )
					sh 'cd ../../sh && ./buildAndArchive-prod-fastlane.sh "$SCHEME" nobumpbuild library'
				end
				
				new_scheme_name = scheme_name + '-Library'
				ENV["SCHEME"] = new_scheme_name
			end

			the_app_name_file = File.open("../targets/#{strType}/#{scheme_name}/metadata/en-US/name.txt", "r")
			contents = the_app_name_file.read
			#puts contents.strip
			
			the_app_price_file = File.open("../targets/#{strType}/#{scheme_name}/metadata/en-US/price.txt", "r")
			price_content = the_app_price_file.read
			#puts price_content.strip

			snapshot(app_identifier: "com.retrieve.retrieveProd#{scheme_name}", output_directory:"./fastlane/build/#{scheme_name}/screenshots",skip_open_summary:true)
    
			version_number = sh 'sed -ne "/^RTI_PRODUCT_VERSION/s/[^0.0-9.0]//gp" ../Config/BuildNumber.xcconfig'
			#puts "-- '#{version_number.strip}' =="
			
			#produce(app_name: contents.strip, app_identifier: "com.retrieve.retrieveProd#{scheme_name}", app_version: '#{version_number.strip}')
			#produce(app_name: contents.strip, app_identifier: "com.retrieve.retrieveProd#{scheme_name}")

			ENV["DELIVER_ITMSTRANSPORTER_ADDITIONAL_UPLOAD_PARAMETERS"] = "-t DAV"
			#deliver(app_identifier: "com.retrieve.retrieveProd#{scheme_name}",submit_for_review:false, app_version: "#{version_number.strip}", metadata_path: "./fastlane/build/#{scheme_name}/metadata",screenshots_path: "./fastlane/build/#{scheme_name}/screenshots",force: true, app_icon: "./fastlane/build/#{scheme_name}/icon.png", app_rating_config_path: "./fastlane/build/#{scheme_name}/ratings.json", price_tier: "#{price_content.strip}", ipa: "./fastlane/build/#{scheme_name}/#{scheme_name}-ReleaseProduction-AppStore.ipa")
		
			end
			
	        #ENV["FIRST_SCHEME"] = array.first
			if (strType == "standalone")
				 sh 'cd ../../sh && ./revert-standalone.sh 2492'
			else
				 sh 'cd ../../sh && ./revert-library.sh 0000'
			end
			sh 'rm -rf  ./../targets'
			
  end
  
  
 
  lane :add_user_data do
  	
	keychain_entry = CredentialsManager::AccountManager.new(user: "developers@retreive.com")
	password = keychain_entry.password
	#puts password
	  
  end
  
  lane :all do |options|
  	array1 = Array.new
	if (options[:type] == "standalone")
		sh 'cd fetch_data && ./grabName.sh standalone all name'
	else
		sh 'cd fetch_data && ./grabName.sh library all name'
	end
	
	line_num=0
	text=File.open('../../sh/temp-all.txt').read
	text.gsub!(/\r\n?/, "\n")
	text.each_line do |line|
  		#print "#{line_num += 1} #{line}"
  		#print "#{line}"
  		array1.push("#{line}".strip)
	end
	
	puts array1
	sh 'cd ../../sh && rm -rf temp-all.txt'
	
  end



  #for example: fastlane validate_data type:standalone appIds:
  #for example: fastlane validate_data type:library appIds:0000,0426
  lane :validate_data do |options|
  		strType = String.new
		strType = options[:type]
		array1 = Array.new
		if (options[:appIds].to_s.strip.length == 0)
			puts "----appIds is nil, empty, or just whitespace"
			if (strType == "standalone")
				sh 'rm -rf  ./../targets/standalone'
				sh 'cd fetch_data && ./grabName.sh standalone all name'
				line_num=0
				text=File.open('../../sh/temp-all.txt').read
				text.gsub!(/\r\n?/, "\n")
				text.each_line do |line|
  					array1.push("#{line}".strip)
				end
				
				puts array1
				sh 'cd ../../sh && rm -rf temp-all.txt'
			else
				sh 'rm -rf  ./../targets/library'
				sh 'cd fetch_data && ./grabName.sh library all name'
				line_num=0
				text=File.open('../../sh/temp-all.txt').read
				text.gsub!(/\r\n?/, "\n")
				text.each_line do |line|
  					array1.push("#{line}".strip)
				end
				
				puts array1
				sh 'cd ../../sh && rm -rf temp-all.txt'
			end
		else
			puts "----appIds is not nil, empty, or just whitespace"
			array1 = options[:appIds].split(",")
			if (strType == "standalone")
				array1.unshift('2492')
			else
				array1.unshift('0000')
			end
			
			puts array1.inspect
		end
		
		array1 = array1.uniq
	    array1.each do |scheme_name|
			ENV["SCHEME"] = scheme_name
		 	
			if (strType == "standalone")
				sh 'cd fetch_data && ./grabData.sh standalone "$SCHEME"'	
			else
			 	sh 'cd fetch_data && ./grabData.sh library "$SCHEME"'	
			end
		end

  end

  lane :standalone_data do
    array = ["2492","2493"]
    array.each do |scheme_name|
     ENV["SCHEME"] = scheme_name
	 puts scheme_name
	 puts "---4--"
	 #sh 'cd fetch_data && ./grabData.sh standalone "$SCHEME"' 
	end
  end
  
  lane :library_data do
	array = ["0000","0426"]
    array.each do |scheme_name|
     ENV["SCHEME"] = scheme_name
	 #sh 'cd fetch_data && ./grabData.sh library "$SCHEME"' 
	end
  end
 
  lane :beta do
  	puts "---------hello-----"
	file = File.open('../targets/standalone/2492/metadata/en-US/name.txt', "r")
	contents = file.read
	puts contents.strip
	puts "--------world------"
  end

  
  lane :test do
    sh 'cd ../../sh && ./a.sh' 
  end

  # You can define as many lanes as you want

  after_all do |lane|
    # This block is called, only if the executed lane was successful

    # slack(
    #   message: "Successfully deployed new App Update."
    # )
  end

  error do |lane, exception|
    # slack(
    #   message: exception.message,
    #   success: false
    # )
  end
end


