TBLProfile = R6::R6Class("TBLProfile", inherit=YATATable,
                         public = list(
                             # Column names
                             ID       = "ID"
                             ,NAME     = "NAME"
                             ,ACTIVE   = "ACTIVE"
                             ,FIAT     = "FIAT"
                             ,CTC      = "CTC"
                             ,MODEL    = "MODEL"
                             ,PROFILE  = "PROFILE"
                             ,SCOPE    = "SCOPE"

                             ,initialize = function() {self$name="Profile"; self$table = "PROFILES"; super$refresh()}
                             ,getFiat    = function() {if (self$nrow() == 0) return (NA);  self$df[1,self$FIAT]    }
                             ,getCTC     = function() {if (self$nrow() == 0) return (NA);  self$df[1,self$CTC]     }
                             ,getModel   = function() {if (self$nrow() == 0) return (NA);  self$df[1,self$MODEL]   }
                             ,getProfile = function() {if (self$nrow() == 0) return (NA);  self$df[1,self$PROFILE] }
                             ,getScope   = function() {if (self$nrow() == 0) return (SCOPE_DAY); self$df[1,self$SCOPE]   }
                         )
                         ,private = list (
                         )
)
