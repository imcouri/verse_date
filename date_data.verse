date_data := class:
    # Default values for the date (January 1, 1970)
    Year : int = 1970
    Month : int = 1
    Day : int = 1

    SECONDS_IN_A_DAY : int = 86400

    # Method to parse an epoch time into a date object
    ParseEpoch(EpochSeconds : float):date_data= 

        var DateData : date_data = date_data{}

        if:
            IntEpochSeconds : int = Round[EpochSeconds]
            EpochDays := IntEpochSeconds / SECONDS_IN_A_DAY
            DaysSinceEpoch : int = Floor(EpochDays)
        then:
            DateVal : tuple(int,int,int) = Self.ConvertDaysToDate(DaysSinceEpoch)
            set DateData = date_data{Year := DateVal(0), Month := DateVal(1), Day := DateVal(2)}

        return DateData

    # Method to convert days since epoch to year, month, and day
    ConvertDaysToDate(DaysSinceEpoch : int) : tuple(int, int, int) =
        var CurrentYear : int = 1970
        var DaysRemaining : int = DaysSinceEpoch

        loop:
            DayCount := Self.DaysInYear(CurrentYear)
            if(DaysRemaining >= DayCount):
                set DaysRemaining -= Self.DaysInYear(CurrentYear)
                set CurrentYear += 1
            else:
                break

        var DaysInMonths : []int = Self.GetDaysInMonths(CurrentYear)
        var CurrentMonth : int = 1

        loop:
            if(DaysRemaining >= DaysInMonths[CurrentMonth - 1]):
                if:
                    set DaysRemaining -= DaysInMonths[CurrentMonth - 1]
                set CurrentMonth += 1
            else:
                break

        return (CurrentYear, CurrentMonth, DaysRemaining + 1)

    # Method to determine the number of days in a year
    DaysInYear(YearVal : int): int =
        return if (IsLeapYear(YearVal)?) then 366 else 365

    # Method to determine if a year is a leap year
    IsLeapYear(YearVal : int)<transacts>: logic =
        return if((Mod[YearVal,4] = 0) and (Mod[YearVal,100] <> 0) or (Mod[YearVal,400] = 0)) then true else false

    # Method to get the number of days in each month for a given year
    GetDaysInMonths(YearVal : int) : []int =
        return if (Self.IsLeapYear(YearVal)?) then array{31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31} else array{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}



#EXAMPLE USAGE - THE CODE BELOW IS NOT A FULL WORKING CODE!!
Game_Manager := class(creative_device):
  OnBegin<override>()<suspends>:void=
        loop:
            CurrentEpochTime := GetSecondsSinceEpoch()
            DateData : date_data = date_data{}.ParseEpoch(CurrentEpochTime)
            Print("Current YEAR : {DateData.Year}, MONTH : {DateData.Month} DAY : {DateData.Day}")
            Sleep(5.0)
      
