#==============================================================================#
# KinesisVideoArchivedMedia.jl
#
# This file is generated from:
# https://github.com/aws/aws-sdk-js/blob/master/apis/kinesis-video-archived-media-2017-09-30.normal.json
#==============================================================================#

__precompile__()

module KinesisVideoArchivedMedia

using AWSCore


"""
    using AWSSDK.KinesisVideoArchivedMedia.get_hlsstreaming_session_url
    get_hlsstreaming_session_url([::AWSConfig], arguments::Dict)
    get_hlsstreaming_session_url([::AWSConfig]; <keyword arguments>)

    using AWSCore.Services.kinesis_video_archived_media
    kinesis_video_archived_media([::AWSConfig], "POST", "/getHLSStreamingSessionURL", arguments::Dict)
    kinesis_video_archived_media([::AWSConfig], "POST", "/getHLSStreamingSessionURL", <keyword arguments>)

# GetHLSStreamingSessionURL Operation

Retrieves an HTTP Live Streaming (HLS) URL for the stream. You can then open the URL in a browser or media player to view the stream contents.

You must specify either the `StreamName` or the `StreamARN`.

An Amazon Kinesis video stream has the following requirements for providing data through HLS:

*   The media type must be `video/h264`.

*   Data retention must be greater than 0.

*   The fragments must contain codec private data in the AVC (Advanced Video Coding) for H.264 format ([MPEG-4 specification ISO/IEC 14496-15](https://www.iso.org/standard/55980.html)). For information about adapting stream data to a given format, see [NAL Adaptation Flags](http://docs.aws.amazon.com/kinesisvideostreams/latest/dg/latest/dg/producer-reference-nal.html).

Kinesis Video Streams HLS sessions contain fragments in the fragmented MPEG-4 form (also called fMP4 or CMAF), rather than the MPEG-2 form (also called TS chunks, which the HLS specification also supports). For more information about HLS fragment types, see the [HLS specification](https://tools.ietf.org/html/draft-pantos-http-live-streaming-23).

The following procedure shows how to use HLS with Kinesis Video Streams:

1.  Get an endpoint using [GetDataEndpoint](http://docs.aws.amazon.com/kinesisvideostreams/latest/dg/API_GetDataEndpoint.html), specifying `GET_HLS_STREAMING_SESSION_URL` for the `APIName` parameter.

2.  Retrieve the HLS URL using `GetHLSStreamingSessionURL`. Kinesis Video Streams creates an HLS streaming session to be used for accessing content in a stream using the HLS protocol. `GetHLSStreamingSessionURL` returns an authenticated URL (that includes an encrypted session token) for the session's HLS *master playlist* (the root resource needed for streaming with HLS).

    **Note**
    > Don't share or store this token where an unauthorized entity could access it. The token provides access to the content of the stream. Safeguard the token with the same measures that you would use with your AWS credentials.

    The media that is made available through the playlist consists only of the requested stream, time range, and format. No other media data (such as frames outside the requested window or alternate bit rates) is made available.

3.  Provide the URL (containing the encrypted session token) for the HLS master playlist to a media player that supports the HLS protocol. Kinesis Video Streams makes the HLS media playlist, initialization fragment, and media fragments available through the master playlist URL. The initialization fragment contains the codec private data for the stream, and other data needed to set up the video decoder and renderer. The media fragments contain H.264-encoded video frames and time stamps.

4.  The media player receives the authenticated URL and requests stream metadata and media data normally. When the media player requests data, it calls the following actions:

    *   **GetHLSMasterPlaylist:** Retrieves an HLS master playlist, which contains a URL for the `GetHLSMediaPlaylist` action, and additional metadata for the media player, including estimated bit rate and resolution.

    *   **GetHLSMediaPlaylist:** Retrieves an HLS media playlist, which contains a URL to access the MP4 initialization fragment with the `GetMP4InitFragment` action, and URLs to access the MP4 media fragments with the `GetMP4MediaFragment` actions. The HLS media playlist also contains metadata about the stream that the player needs to play it, such as whether the `PlaybackMode` is `LIVE` or `ON_DEMAND`. The HLS media playlist is typically static for sessions with a `PlaybackType` of `ON_DEMAND`. The HLS media playlist is continually updated with new fragments for sessions with a `PlaybackType` of `LIVE`.

    *   **GetMP4InitFragment:** Retrieves the MP4 initialization fragment. The media player typically loads the initialization fragment before loading any media fragments. This fragment contains the "`fytp`" and "`moov`" MP4 atoms, and the child atoms that are needed to initialize the media player decoder.

        The initialization fragment does not correspond to a fragment in a Kinesis video stream. It contains only the codec private data for the stream, which the media player needs to decode video frames.

    *   **GetMP4MediaFragment:** Retrieves MP4 media fragments. These fragments contain the "`moof`" and "`mdat`" MP4 atoms and their child atoms, containing the encoded fragment's video frames and their time stamps.

        **Note**
        > After the first media fragment is made available in a streaming session, any fragments that don't contain the same codec private data are excluded in the HLS media playlist. Therefore, the codec private data does not change between fragments in a session.

        Data retrieved with this action is billable. See [Pricing](aws.amazon.comkinesis/video-streams/pricing/) for details.

**Note**
> The following restrictions apply to HLS sessions:

*   A streaming session URL should not be shared between players. The service might throttle a session if multiple media players are sharing it. For connection limits, see [Kinesis Video Streams Limits](http://docs.aws.amazon.com/kinesisvideostreams/latest/dg/limits.html).

*   A Kinesis video stream can have a maximum of five active HLS streaming sessions. If a new session is created when the maximum number of sessions is already active, the oldest (earliest created) session is closed. The number of active `GetMedia` connections on a Kinesis video stream does not count against this limit, and the number of active HLS sessions does not count against the active `GetMedia` connection limit.

You can monitor the amount of data that the media player consumes by monitoring the `GetMP4MediaFragment.OutgoingBytes` Amazon CloudWatch metric. For information about using CloudWatch to monitor Kinesis Video Streams, see [Monitoring Kinesis Video Streams](http://docs.aws.amazon.com/kinesisvideostreams/latest/dg/monitoring.html). For pricing information, see [Amazon Kinesis Video Streams Pricing](https://aws.amazon.com/kinesis/video-streams/pricing/) and [AWS Pricing](https://aws.amazon.com/pricing/). Charges for both HLS sessions and outgoing AWS data apply.

For more information about HLS, see [HTTP Live Streaming](https://developer.apple.com/streaming/) on the [Apple Developer site](https://developer.apple.com).

# Arguments

## `StreamName = ::String`
The name of the stream for which to retrieve the HLS master playlist URL.

You must specify either the `StreamName` or the `StreamARN`.


## `StreamARN = ::String`
The Amazon Resource Name (ARN) of the stream for which to retrieve the HLS master playlist URL.

You must specify either the `StreamName` or the `StreamARN`.


## `PlaybackMode = "LIVE" or "ON_DEMAND"`
Whether to retrieve live or archived, on-demand data.

Features of the two types of session include the following:

*   **`LIVE`** : For sessions of this type, the HLS media playlist is continually updated with the latest fragments as they become available. We recommend that the media player retrieve a new playlist on a one-second interval. When this type of session is played in a media player, the user interface typically displays a "live" notification, with no scrubber control for choosing the position in the playback window to display.

    **Note**
    > In `LIVE` mode, the newest available fragments are included in an HLS media playlist, even if there is a gap between fragments (that is, if a fragment is missing). A gap like this might cause a media player to halt or cause a jump in playback. In this mode, fragments are not added to the HLS media playlist if they are older than the newest fragment in the playlist. If the missing fragment becomes available after a subsequent fragment is added to the playlist, the older fragment is not added, and the gap is not filled.

*   **`ON_DEMAND`** : For sessions of this type, the HLS media playlist contains all the fragments for the session, up to the number that is specified in `MaxMediaPlaylistFragmentResults`. The playlist must be retrieved only once for each session. When this type of session is played in a media player, the user interface typically displays a scrubber control for choosing the position in the playback window to display.

In both playback modes, if `FragmentSelectorType` is `PRODUCER_TIMESTAMP`, and if there are multiple fragments with the same start time stamp, the fragment that has the larger fragment number (that is, the newer fragment) is included in the HLS media playlist. The other fragments are not included. Fragments that have different time stamps but have overlapping durations are still included in the HLS media playlist. This can lead to unexpected behavior in the media player.

The default is `LIVE`.


## `HLSFragmentSelector = [ ... ]`
The time range of the requested fragment, and the source of the time stamps.

This parameter is required if `PlaybackMode` is `ON_DEMAND`. This parameter is optional if `PlaybackMode` is `LIVE`. If `PlaybackMode` is `LIVE`, the `FragmentSelectorType` can be set, but the `TimestampRange` should not be set. If `PlaybackMode` is `ON_DEMAND`, both `FragmentSelectorType` and `TimestampRange` must be set.
```
 HLSFragmentSelector = [
        "FragmentSelectorType" =>  "PRODUCER_TIMESTAMP" or "SERVER_TIMESTAMP",
        "TimestampRange" =>  [
            "StartTimestamp" =>  timestamp,
            "EndTimestamp" =>  timestamp
        ]
    ]
```

## `DiscontinuityMode = "ALWAYS" or "NEVER"`
Specifies when flags marking discontinuities between fragments will be added to the media playlists. The default is `ALWAYS` when [HLSFragmentSelector](@ref) is `SERVER_TIMESTAMP`, and `NEVER` when it is `PRODUCER_TIMESTAMP`.

Media players typically build a timeline of media content to play, based on the time stamps of each fragment. This means that if there is any overlap between fragments (as is typical if [HLSFragmentSelector](@ref) is `SERVER_TIMESTAMP`), the media player timeline has small gaps between fragments in some places, and overwrites frames in other places. When there are discontinuity flags between fragments, the media player is expected to reset the timeline, resulting in the fragment being played immediately after the previous fragment. We recommend that you always have discontinuity flags between fragments if the fragment time stamps are not accurate or if fragments might be missing. You should not place discontinuity flags between fragments for the player timeline to accurately map to the producer time stamps.


## `Expires = ::Int`
The time in seconds until the requested session expires. This value can be between 300 (5 minutes) and 43200 (12 hours).

When a session expires, no new calls to `GetHLSMasterPlaylist`, `GetHLSMediaPlaylist`, `GetMP4InitFragment`, or `GetMP4MediaFragment` can be made for that session.

The default is 300 (5 minutes).


## `MaxMediaPlaylistFragmentResults = ::Int`
The maximum number of fragments that are returned in the HLS media playlists.

When the `PlaybackMode` is `LIVE`, the most recent fragments are returned up to this value. When the `PlaybackMode` is `ON_DEMAND`, the oldest fragments are returned, up to this maximum number.

When there are a higher number of fragments available in a live HLS media playlist, video players often buffer content before starting playback. Increasing the buffer size increases the playback latency, but it decreases the likelihood that rebuffering will occur during playback. We recommend that a live HLS media playlist have a minimum of 3 fragments and a maximum of 10 fragments.

The default is 5 fragments if `PlaybackMode` is `LIVE`, and 1,000 if `PlaybackMode` is `ON_DEMAND`.

The maximum value of 1,000 fragments corresponds to more than 16 minutes of video on streams with 1-second fragments, and more than 2 1/2 hours of video on streams with 10-second fragments.




# Returns

`GetHLSStreamingSessionURLOutput`

# Exceptions

`ResourceNotFoundException`, `InvalidArgumentException`, `ClientLimitExceededException`, `NotAuthorizedException`, `UnsupportedStreamMediaTypeException`, `NoDataRetentionException`, `MissingCodecPrivateDataException` or `InvalidCodecPrivateDataException`.

See also: [AWS API Documentation](https://docs.aws.amazon.com/goto/WebAPI/kinesis-video-archived-media-2017-09-30/GetHLSStreamingSessionURL)
"""
@inline get_hlsstreaming_session_url(aws::AWSConfig=default_aws_config(); args...) = get_hlsstreaming_session_url(aws, args)

@inline get_hlsstreaming_session_url(aws::AWSConfig, args) = AWSCore.Services.kinesis_video_archived_media(aws, "POST", "/getHLSStreamingSessionURL", args)

@inline get_hlsstreaming_session_url(args) = get_hlsstreaming_session_url(default_aws_config(), args)


"""
    using AWSSDK.KinesisVideoArchivedMedia.get_media_for_fragment_list
    get_media_for_fragment_list([::AWSConfig], arguments::Dict)
    get_media_for_fragment_list([::AWSConfig]; StreamName=, Fragments=)

    using AWSCore.Services.kinesis_video_archived_media
    kinesis_video_archived_media([::AWSConfig], "POST", "/getMediaForFragmentList", arguments::Dict)
    kinesis_video_archived_media([::AWSConfig], "POST", "/getMediaForFragmentList", StreamName=, Fragments=)

# GetMediaForFragmentList Operation

Gets media for a list of fragments (specified by fragment number) from the archived data in an Amazon Kinesis video stream.

The following limits apply when using the `GetMediaForFragmentList` API:

*   A client can call `GetMediaForFragmentList` up to five times per second per stream.

*   Kinesis Video Streams sends media data at a rate of up to 25 megabytes per second (or 200 megabits per second) during a `GetMediaForFragmentList` session.

# Arguments

## `StreamName = ::String` -- *Required*
The name of the stream from which to retrieve fragment media.


## `Fragments = [::String, ...]` -- *Required*
A list of the numbers of fragments for which to retrieve media. You retrieve these values with [ListFragments](@ref).




# Returns

`GetMediaForFragmentListOutput`

# Exceptions

`ResourceNotFoundException`, `InvalidArgumentException`, `ClientLimitExceededException` or `NotAuthorizedException`.

See also: [AWS API Documentation](https://docs.aws.amazon.com/goto/WebAPI/kinesis-video-archived-media-2017-09-30/GetMediaForFragmentList)
"""
@inline get_media_for_fragment_list(aws::AWSConfig=default_aws_config(); args...) = get_media_for_fragment_list(aws, args)

@inline get_media_for_fragment_list(aws::AWSConfig, args) = AWSCore.Services.kinesis_video_archived_media(aws, "POST", "/getMediaForFragmentList", args)

@inline get_media_for_fragment_list(args) = get_media_for_fragment_list(default_aws_config(), args)


"""
    using AWSSDK.KinesisVideoArchivedMedia.list_fragments
    list_fragments([::AWSConfig], arguments::Dict)
    list_fragments([::AWSConfig]; StreamName=, <keyword arguments>)

    using AWSCore.Services.kinesis_video_archived_media
    kinesis_video_archived_media([::AWSConfig], "POST", "/listFragments", arguments::Dict)
    kinesis_video_archived_media([::AWSConfig], "POST", "/listFragments", StreamName=, <keyword arguments>)

# ListFragments Operation

Returns a list of [Fragment](@ref) objects from the specified stream and start location within the archived data.

# Arguments

## `StreamName = ::String` -- *Required*
The name of the stream from which to retrieve a fragment list.


## `MaxResults = ::Int`
The total number of fragments to return. If the total number of fragments available is more than the value specified in `max-results`, then a [ListFragmentsOutput\$NextToken](@ref) is provided in the output that you can use to resume pagination.


## `NextToken = ::String`
A token to specify where to start paginating. This is the [ListFragmentsOutput\$NextToken](@ref) from a previously truncated response.


## `FragmentSelector = [ ... ]`
Describes the time stamp range and time stamp origin for the range of fragments to return.
```
 FragmentSelector = [
        "FragmentSelectorType" => <required> "PRODUCER_TIMESTAMP" or "SERVER_TIMESTAMP",
        "TimestampRange" => <required> [
            "StartTimestamp" => <required> timestamp,
            "EndTimestamp" => <required> timestamp
        ]
    ]
```



# Returns

`ListFragmentsOutput`

# Exceptions

`ResourceNotFoundException`, `InvalidArgumentException`, `ClientLimitExceededException` or `NotAuthorizedException`.

See also: [AWS API Documentation](https://docs.aws.amazon.com/goto/WebAPI/kinesis-video-archived-media-2017-09-30/ListFragments)
"""
@inline list_fragments(aws::AWSConfig=default_aws_config(); args...) = list_fragments(aws, args)

@inline list_fragments(aws::AWSConfig, args) = AWSCore.Services.kinesis_video_archived_media(aws, "POST", "/listFragments", args)

@inline list_fragments(args) = list_fragments(default_aws_config(), args)




end # module KinesisVideoArchivedMedia


#==============================================================================#
# End of file
#==============================================================================#
