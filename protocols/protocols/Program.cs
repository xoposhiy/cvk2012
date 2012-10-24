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
		private static Dictionary<string, bool> deactivated = new Dictionary<string, bool>();

		static void Main(string[] args)
		{
			Console.WriteLine("loading options...");
			options = LoadOptions("options.csv");
			mmmOptions = LoadOptions("mmm_candidates.csv");
			Console.WriteLine("loading voters...");
			var lines = File.ReadAllLines("voters.csv").Skip(1).Select(line => line.Split(';')).ToList();
			Console.WriteLine("parsing voters...");
			deactivated = lines.ToDictionary(parts => parts[0] + parts[2].Substring(3), parts => parts[3].Contains("Deactivated"));
			voters = lines.ToDictionary(parts => parts[0] + parts[2].Substring(3), parts => parts[1]); //id+phone => datetime
			Console.WriteLine("voters: {0}", voters.Count);

			
			Console.WriteLine("decrypting...");
			var decrypted = new Blowfish(File.ReadAllText("key.txt")).decryptString(File.ReadAllText("protocol.csv"));
			File.WriteAllText("decrypted.csv", decrypted);
			Console.WriteLine("filtering...");
			var voteLines = decrypted.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries).Skip(1).Select(line => line.Split(';'));
			var votes = voteLines
				.Select(
				parts => new
					{
						voter = parts[0] + parts[1],  //id + phone
						candidates = parts[2].Split(',').ToArray()
					}).ToList();
			Console.WriteLine("deactivated count: " + deactivated.Count(kv => kv.Value)); // не 0
			Console.WriteLine("Votes by deactivated: " + votes.Count(v => deactivated[v.voter])); //0
			Console.WriteLine("Voters with more than 45 votes: " + votes.Count(v => v.candidates.Count() > 45)); //0
			Console.WriteLine("Voters with duplicated votes: " + votes.Count(v => v.candidates.Distinct().Count() != v.candidates.Count())); //0
			Console.WriteLine("Voters with more than 45 UNIQUE votes: " + votes.Count(v => v.candidates.Distinct().Count() > 45)); //0
			
			Console.WriteLine("Banned MMMs: " + votes.Count(v => IsMmm(v.voter, v.candidates)));

			var results = votes
				.Where(v => !IsMmm(v.voter, v.candidates) && !deactivated[v.voter])
				.SelectMany(v => v.candidates.Distinct())
				.GroupBy(cand => cand)
				.ToDictionary(g => g.Key, g => g.Count());
			Console.WriteLine("results:");
			foreach (var res in results.OrderByDescending(kv => kv.Value))
			{
				Console.WriteLine(res.Value + "\t" + options[res.Key]);
			}
			Console.WriteLine("Elliminate ALL MMM:");
			Console.WriteLine("Banned ALL MMMs: " + votes.Count(v => IsMmmAll(v.voter, v.candidates)));
			Console.WriteLine("results:");
			var results2 = votes
				.Where(v => !IsMmmAll(v.voter, v.candidates) && !deactivated[v.voter])
				.SelectMany(v => v.candidates.Distinct())
				.GroupBy(cand => cand)
				.ToDictionary(g => g.Key, g => g.Count());
			foreach (var res in results2.OrderByDescending(kv => kv.Value))
			{
				Console.WriteLine(res.Value + "\t" + options[res.Key]);
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

		private static bool IsMmmAll(string voter, string[] candidates)
		{
			if (!voters.ContainsKey(voter))
				throw new Exception(voter);
			return candidates.Distinct().Count(mmmOptions.ContainsKey) > 15 || candidates.All(mmmOptions.ContainsKey) && candidates.Count() > 10;
		}
	}
}
