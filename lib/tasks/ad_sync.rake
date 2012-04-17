require 'rake'
require 'stringio'
load 'AdSync.rb'

namespace :ad do
  desc 'Sync the user database with Active Directory'
  task :sync do
    Rake::Task['environment'].invoke
    
    # Keep a log to e-mail to the admins
    log = StringIO.new
    
    # Cached groups list
    groups = {}
    
    timestamp_start = Time.now
    
    # Cache group 'dss-us-auto-all' because we always need it
    groups["dss-us-auto-all"] = AdSync.fetch_group("dss-us-auto-all")
    if groups["dss-us-auto-all"].nil?
      log << "Error: Could not load group dss-us-auto-all\n"
    end
    
    i = 1
    length = Person.all.length
    Person.all.each do |p|
      changed = false # flag used to indicate whether we should print 'no changes' or not for each record
      
      log << "Syncing #{p.loginid} (#{i} of #{length})\n"
      i += 1
      
      ad_user = AdSync.fetch_user(p.loginid)
      if ad_user.nil?
        log << "\tCould not find user in AD\n"
      end
      
      # Write them to all group (dss-us-auto-all) if necessary
      unless AdSync.in_group(ad_user, groups["dss-us-auto-all"])
        changed = true
        if AdSync.add_user_to_group(ad_user, groups["dss-us-auto-all"]) == false
          log << "\tWarning: Needed to add to dss-us-auto-all but operation failed\n"
        else
          log << "\tAdded to dss-us-auto-all\n"
        end
      else
        log << "\tAlready in dss-us-auto-all\n"
      end
      
      p.affiliations.each do |affiliation|
        # Write them to cluster-name-affiliation (dss-us-#{ou_to_short}-#{flatten_affiliation})
        unless p.ous.length == 0
          short_ou = ou_to_short(p.ous[0].name)
          flattened_affiliation = flatten_affiliation(affiliation.name)
          unless short_ou.nil? or flattened_affiliation.nil?
            # Write them to cluster-affiliation-all
            caa = "dss-us-#{short_ou}-#{flattened_affiliation}".downcase
            # Cache group if necessary
            if groups[caa].nil?
              groups[caa] = AdSync.fetch_group(caa)
            end
            unless AdSync.in_group(ad_user, groups[caa])
              changed = true
              if AdSync.add_user_to_group(ad_user, groups[caa]) == false
                log << "\tWarning: Needed to add to #{caa} but operation failed\n"
              else
                log << "\tAdded to #{caa}\n"
              end
            else
              log << "\tAlready in #{caa}\n"
            end
            
            # Write them to cluster-all (dss-us-#{ou_to_short}-all)
            ca = "dss-us-#{short_ou}-all".downcase
            # Cache group if necessary
            if groups[ca].nil?
              groups[ca] = AdSync.fetch_group(ca)
            end
            unless AdSync.in_group(ad_user, groups[caa])
              changed = true
              if AdSync.add_user_to_group(ad_user, groups[ca]) == false
                log << "\tWarning: Needed to add to #{ca} but operation failed\n"
              else
                log << "\tAdded to #{ca}\n"
              end
            else
              log << "\tAlready in #{ca}\n"
            end
          end
        end
      end
      
      unless changed
        log << "\tUp to date.\n"
      end
    end
    
    timestamp_finish = Time.now
    
    log << "\nAD Sync took " + (timestamp_finish - timestamp_start).to_s + "s\n"
    
    # Email the log
    WheneverMailer.adsync_report(log.string).deliver!
  end
end

def ou_to_short(name)
  name = name.upcase
  
  case name
  when "DSS IT SERVICE CENTER"
    "IT"
  when "DSS HR/PAYROLL SERVICE CENTER"
    "HR"
  when "CALIFORNIA HISTORY SS PROJECT"
    "CHP"
  when "UC CENTER SACRAMENTO"
    "UCCS"
  when "HEMISPHERIC INSTITUTE-AMERICAS"
    "PHE"
  when "HISTORY PROJECT"
    "HP"
  when "SOCIAL SCIENCES PROGRAM"
    "SSP"
  when "PHYSICAL EDUCATION PROGRAM"
    "PHE"
  when "DSS RESEARCH SERVICE CENTER"
    "RSC"
  when "GEOGRAPHY"
    "GEO"
  when "ANTHROPOLOGY"
    "ANT"
  when "COMMUNICATION"
    "CMN"
  when "ECONOMICS"
    "ECN"
  when "HISTORY"
    "HIS"
  when "LINGUISTICS"
    "LIN"
  when "MILITARY SCIENCE"
    "MSC"
  when "PHILOSOPHY"
    "PHI"
  when "POLITICAL SCIENCE"
    "POL"
  when "PSYCHOLOGY"
    "PSC"
  when "EASTERN ASIAN STUDIES"
    "EAS"
  when "INTERNATIONAL RELATIONS"
    "IRE"
  when "MIDDLE EAST/SOUTH ASIA STUDIES"
    "MSA"
  when "SCIENCE & TECHNOLOGY STUDIES"
    "STS"
  when "CENTER FOR MIND AND BRAIN"
    "CMB"
  when "SOCIOLOGY"
    "SOC"
  when "COM, PHIL & LIN RED CLUSTER"
    "RED"
  when "POLI SCI, IR ORANGE CLUSTER"
    "ORANGE"
  when "ECON, HIS, MS BLUE CLUSTER"
    "BLUE"
  when "ANT, SOC GREEN CLUSTER"
    "GREEN"
  when "L&S DEANS - SOCIAL SCIENCES"
    "DEANS"
  when "PSYCH, CMB YELLOW CLUSTER"
    "YELLOW"
  when "EDUCATION - PH.D."
    "EDU"
  when "COMMUNITY DEVELOPMENT"
    "ComDev"
  when "NEUROSCIENCE"
    "NueroSci"
  when "CENTER FOR INNOVATION STUDIES"
    "CSIS"
  else
    puts "Missing OU: #{name}"
  end
end

def flatten_affiliation(affiliation)
  if affiliation.include? "staff" and not (affiliation.include? ":")
    return "staff-academic"
  end
  
  case affiliation
  when "faculty:senate"
    "faculty"
  when "faculty:federation"
    "lecturer"
  when "staff:career"
    "staff"
  when "staff:casual"
    "staff"
  when "staff:contract"
    "staff"
  when "staff:student"
    "staff-student"
  when "student:graduate"
    "student-graduate"
  when "visitor:student:graduate"
    "student-graduate"
  when "faculty"
    "faculty"
  else
    puts "Missing affiliation: #{affiliation}"
  end
end