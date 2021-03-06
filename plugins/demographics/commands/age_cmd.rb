module AresMUSH
  module Demographics

    class AgeCmd
      include CommandHandler
      
      attr_accessor :age
      
      def required_args
        [ self.age ]
      end
         
      def check_chargen_locked
        Chargen.check_chargen_locked(enactor)
      end
      
      def parse_args
        self.age = integer_arg(cmd.args)
      end
      
      def handle
        error = Demographics.check_age(self.age)
        if (error)
          client.emit_failure error
          return
        end
        
        bday = Demographics.set_random_birthdate(enactor, self.age)
        
        client.emit_success t('demographics.birthdate_set', 
          :birthdate => ICTime.ic_datestr(bday), 
          :age => enactor.age)
      end
        
    end
    
  end
end