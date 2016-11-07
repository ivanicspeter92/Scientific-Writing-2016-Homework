package com.example.peterivanics.dutycyclingdemo;

import java.util.Calendar;
import java.util.Timer;
import java.util.TimerTask;

import android.location.Location;
import android.location.LocationManager;
import android.util.Log;

/**
 * Created by peter.ivanics on 05/11/2016.
 */

public class DutyCycling {
    /**
     * The last known movement speed of the user in [m/s].
     */
    private double movementSpeed;
    /**
     * The error treshold [meters].
     */
    private double treshold;
    /**
     * The Location object retrieved from the service provider. Performing calls on this object will communicate with the provider and should be done only during the duty cycle.
     */
    private Location currentLocation = new Location(LocationManager.GPS_PROVIDER);
    /**
     * The timestamp when the last coordinates were retrieved.
     */
    private Calendar lastPollingTimestamp;
    /**
     * The last known coordinates of the device.
     */
    private GPSCoordinates coordinates;
    /**
     * The estimated error of the last known location [meters].
     */
    private double estimatedError = 0;
    private Timer timer = new Timer();

    public DutyCycling(double movementSpeed, double treshold) {
        Log.d("CREATION", "Duty cycling initiated!");
        this.movementSpeed = movementSpeed;
        this.treshold = treshold;
    }

    /**
     * Getter method for the coordinates field.
     *
     * @return The value of the coordinates field.
     */
    public GPSCoordinates getCoordinates() {
        return this.coordinates;
    }

    /**
     * Calculates how often the GPS coordinates should be refreshed using the formula (treshold - estimated error) / movement speed [seconds].
     *
     * @return The delta t value which is equivalent to the polling time of the GPS coordinates.
     */
    public double getDeltaTimeSeconds() {
        return (this.treshold - this.estimatedError) / this.movementSpeed;
    }

    /**
     * Starts the timer for the DutyCycling.
     */
    public void start() {
        this.refreshCoordinates();
        Log.d("STATE", "Duty cycling started! Frequency: " + this.getDeltaTimeSeconds());
        this.timer.schedule(new TimerTask() {
            @Override
            public void run() {
                refreshCoordinatesIfTimeHasElapsed();
            }
        }, 0, (int)(this.getDeltaTimeSeconds()) * 1000);
    }

    /**
     * Stops the timer for the DutyCycling.
     */
    public void stop(){
        this.timer.cancel();
    }

    private void refreshCoordinatesIfTimeHasElapsed() {
        Log.d("STATE", "Checking if time has elapsed...");
        if (this.areLastCoordinatesExpired()) {
            this.refreshCoordinates();
        } else {
            Log.d("STATE", "No need to refresh coordinates, sleeping...");
        }
    }

    private boolean areLastCoordinatesExpired() {
        Calendar currentDate = Calendar.getInstance();
        currentDate.add(Calendar.SECOND, -1 * (int)this.getDeltaTimeSeconds());

        if (currentDate.after(this.lastPollingTimestamp)) {
            return true;
        }
        return false;
    }

    private void refreshCoordinates() {
        this.coordinates = new GPSCoordinates(this.currentLocation.getLatitude(), this.currentLocation.getLongitude());

        this.refreshTrackingVariables();
        Log.d("STATE", "Coordinates refreshed! New coordinates: (" + this.coordinates.latitude + ", " + this.coordinates.longitude + ")");
    }

    /**
     * Refreshes the tracking variables after a successful location update.
     */
    private void refreshTrackingVariables() {
        this.lastPollingTimestamp = Calendar.getInstance();
        //this.movementSpeed = this.currentLocation.getSpeed(); //\TODO
        //this.estimatedError = this.currentLocation.getError(); //\TODO
    }
}
