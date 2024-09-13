using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Text.Json.Serialization.Metadata;
using System.Threading.Tasks;

namespace webapi
{
    [JsonSerializable(typeof(WeatherForecast))]
    [JsonSerializable(typeof(WeatherForecast[]))]
    internal partial class JsonContext : JsonSerializerContext
    {
    }
}