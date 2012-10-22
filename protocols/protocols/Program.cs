using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using org.jivesoftware.util;

namespace protocols
{
	class Program
	{
		private static Dictionary<string, string> mmmOptions;
		private static Dictionary<string, string> options;
		private static Dictionary<string, string> voters;

		static void Main(string[] args)
		{
			Console.WriteLine("loading options...");
			options = LoadOptions("options.csv");
			mmmOptions = LoadOptions("mmm_candidates.csv");
			Console.WriteLine("loading voters...");
			var lines = File.ReadAllLines("voters.csv").Skip(1).Select(line => line.Split(';')).ToList();
			Console.WriteLine("parsing voters...");

			voters = new Dictionary<string, string>();
			foreach (var parts in lines)
			{
				voters[parts[0]] = parts[1];
//				Console.WriteLine(parts[0]);
			}
			
			
			Console.WriteLine("decrypting...");
			var decrypted = new Blowfish(File.ReadAllText("key.txt")).decryptString(File.ReadAllText("protocol.csv"));
			File.WriteAllText("decrypted.csv", decrypted);
			Console.WriteLine("filtering...");
			var voteLines = decrypted.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries).Skip(1);
			var votes = voteLines.Select(v => new { voter = v.Split(';')[0], candidates = v.Split(';')[2].Split(',').ToArray() }).ToList();
			var results = votes.Where(v => !IsMmm(v.voter, v.candidates)).SelectMany(v => v.candidates).GroupBy(cand => cand).ToDictionary(g => g.Key, g => g.Count());
			Console.WriteLine("results:");
			foreach (var res in results.OrderByDescending(kv => kv.Value))
			{
				Console.WriteLine(res.Value + "\t" + res.Key + "\t" + options[res.Key]);
			}
		}

		private static DateTime ParseDateTime(string s)
		{
			return DateTime.ParseExact(s, "MM/dd/yyyy HH:mm:ss", new CultureInfo("en"));
		}

		private static Dictionary<string, string> LoadOptions(string filename)
		{
			return File.ReadAllLines(filename, Encoding.GetEncoding(1251)).Skip(1).Select(line => line.Split(';')).ToDictionary(parts => "" + (int.Parse(parts[0]) - 1), parts => parts[1]);
		}

		private static bool IsMmm(string voter, string[] candidates)
		{
			if (!voters.ContainsKey(voter))
				throw new Exception(voter);
			return candidates.Distinct().Count(mmmOptions.ContainsKey) == 38 && ParseDateTime(voters[voter]) > new DateTime(2012, 10, 16, 12, 0, 0);
		}
	}
}
