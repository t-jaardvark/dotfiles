function time_until
    if test (count $argv) -ne 1
        echo "Usage: time_until <time>"
        echo "Time format: HH:MM, HHMM, H:MM, or HMM"
        return 1
    end

    # Parse the input time
    set input $argv[1]
    set parsed_time (string replace -r ':' '' $input)

    # Pad with leading zeros if necessary
    switch (string length $parsed_time)
        case 1 2
            set parsed_time "0$parsed_time"00
        case 3
            set parsed_time "0$parsed_time"
    end

    # Extract hours and minutes
    set hours (string sub -l 2 $parsed_time)
    set minutes (string sub -s 3 -l 2 $parsed_time)

    # Validate hours and minutes
    if test $hours -ge 24 -o $minutes -ge 60
        echo "Invalid time format. Please use HH:MM (24-hour format)."
        return 1
    end

    # Format the time for display
    set -gx TIME_UNTIL__TIME (printf "%02d:%02d" $hours $minutes)

    # Calculate seconds until the next occurrence
    set current_time (date +%s)
    set target_time (date -d "$TIME_UNTIL__TIME" +%s)

    if test $target_time -le $current_time
        # If the target time is in the past, add 24 hours
        set target_time (math $target_time + 86400)
    end

    set -gx TIME_UNTIL__SECONDS (math $target_time - $current_time)

    # Output the results
    echo "Target time: $TIME_UNTIL__TIME"
    echo "Seconds until target: $TIME_UNTIL__SECONDS"
end
